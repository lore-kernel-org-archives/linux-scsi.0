From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Tue, 19 Oct 2004 16:58:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41758003.2060005@adaptec.com>
References: <Pine.LNX.4.44L0.0410151432250.1052-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030809010505060400050904"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33501 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269406AbUJSU7B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 16:59:01 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410151432250.1052-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030809010505060400050904
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Alan Stern wrote:
> A number of USB mass storage devices incorrectly return the total number
> of blocks rather than the largest block number in response to READ
> CAPACITY.  They then go on to compound the problem by not returning
> "Logical block address out of range" sense when asked to read the "last"
> block; instead they mess up the protocol and don't send any status phase
> information.
> 
> The usb-storage driver has been dealing with this by adding blacklist
> entries for these devices, but this isn't a very good solution.  After
> all, it's not a transport problem -- and it's not a good idea for a
> low-level driver to change the data being sent by a device.
> 
> Instead the adjustment should be made in sd.c, in the sd_read_capacity()
> routine.  One possibility is to have a SCSI blacklist flag for the bad
> devices.  A better choice might be to correct the mistake at runtime. 
> Using the heuristic that the total number of blocks is almost always even
> (as far as I know it is _always_ even for USB disk-like devices), we could
> try to read the last block whenever READ CAPACITY reports an odd number of
> blocks.  If the read fails then we would know to decrement the number.
> 
> Does either of these sound like a good idea?  And if the second choice
> sounds better, is there anyone who could help me to write such a patch?

Alan, do you have such a USB device handy?

A third possibility is to use the PMI bit to get the proper value
of the LBA of the last logical block.

If you want to move this into sd, then do you know if those
devices support the use of PMI bit in READ CAPACITY CDB?
As block devices they should.

See the appended/attached patch.  Can you test it against such a USB
device?

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

===== drivers/scsi/sd.c 1.161 vs edited =====
--- 1.161/drivers/scsi/sd.c	2004-10-15 10:46:07 -04:00
+++ edited/drivers/scsi/sd.c	2004-10-19 16:51:46 -04:00
@@ -987,6 +987,112 @@
  	}
  }

+/* sd_read_true_cap: Some device servers incorrectly return the
+ * capacity as opposed to the LBA of the last logical block of the
+ * block device.
+ *
+ * We try to fix this as follows: Let x = Returned LBA from the last
+ * READ CAPACITY command issued (result in "buffer").  Reissue the
+ * READ CAPACITY command as follows: set the partial medium indicator
+ * (PMI) bit to one; set the LBA to x - 1. Fire off that READ CAPACITY
+ * command.
+ *
+ * If we get success,
+ *       If Returned LBA > x - 1, then capacity is x+1, spec behavior.
+ *       Else Returned LBA <= x - 1, then capacity is x, broken device server.
+ * Else error, nothing can be assumed, capacity is x+1.
+ */
+#define GET_RLBA_READ_CAP16(_buffer) (((u64)(_buffer)[0] << 56) | \
+				     ((u64)(_buffer)[1] << 48) |  \
+				     ((u64)(_buffer)[2] << 40) |  \
+				     ((u64)(_buffer)[3] << 32) |  \
+				     ((sector_t)(_buffer)[4] << 24) | \
+				     ((sector_t)(_buffer)[5] << 16) | \
+				     ((sector_t)(_buffer)[6] << 8)  | \
+				     (sector_t)(_buffer)[7])
+#define GET_RLBA_READ_CAP10(_buffer) (((sector_t)(_buffer)[0] << 24) | \
+				      ((_buffer)[1] << 16) |           \
+				      ((_buffer)[2] << 8) |            \
+				      (_buffer)[3])
+static void sd_read_true_cap(struct scsi_disk *sd, char *diskname,
+			     struct scsi_request *SRpnt, unsigned char *buffer,
+			     int longrc)
+{
+	unsigned char cmd[16];
+	unsigned char buf[12];
+
+	/* save the old buffer contents here */
+	memcpy(buf, buffer, 12);
+
+	if (longrc) {
+		u64 *lba = (u64 *) (cmd+2);
+		u64 rlba;
+
+		memset((void *) cmd, 0, 16);
+		cmd[0] = SERVICE_ACTION_IN;
+		cmd[1] = SAI_READ_CAPACITY_16;
+		cmd[13] = 12;
+
+		rlba = GET_RLBA_READ_CAP16(buffer);
+		rlba -= 1;
+		*lba = cpu_to_be64(rlba);
+		/* turn on the PMI bit */
+		cmd[14] |= 1;
+		memset((void *) buffer, 0, 12);
+	} else {
+		u32 *lba = (u32 *) (cmd+2);
+		u32 rlba;
+
+		cmd[0] = READ_CAPACITY;
+		memset((void *) &cmd[1], 0, 9);
+		
+		rlba = GET_RLBA_READ_CAP10(buffer);
+		rlba -= 1;
+		*lba = cpu_to_be32(rlba);
+		/* turn on the PMI bit */
+		cmd[8] |= 1;
+		memset((void *) buffer, 0, 8);
+	}
+
+	SRpnt->sr_cmd_len = 0;
+	SRpnt->sr_sense_buffer[0] = 0;
+	SRpnt->sr_sense_buffer[2] = 0;
+	SRpnt->sr_data_direction = DMA_FROM_DEVICE;
+	
+	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
+		      longrc ? 12 : 8, SD_TIMEOUT, SD_MAX_RETRIES);
+
+	if (SRpnt->sr_result) {
+		/* Nothing can be assumed. */
+		printk(KERN_NOTICE "%s: %s: PMI not supported\n",
+		       __FUNCTION__, diskname);
+		memcpy(buffer, buf, 12);
+		return;
+	}
+
+	if (longrc) {
+		u64 rlba = GET_RLBA_READ_CAP16(buffer);
+		u64 x    = GET_RLBA_READ_CAP16(buf);
+		if (rlba > x - 1) {
+			goto out_spec;
+		}
+	} else {
+		u32 rlba = GET_RLBA_READ_CAP10(buffer);
+		u32 x    = GET_RLBA_READ_CAP10(buf);
+		if (rlba > x - 1) {
+			goto out_spec;
+		}
+	}
+	printk(KERN_NOTICE "%s: %s: broken device server\n", __FUNCTION__,
+	       diskname);
+	return;
+	
+ out_spec:
+	/* Capacity is x+1, spec behavior. */
+	printk(KERN_NOTICE "%s: %s: spec behavior\n", __FUNCTION__, diskname);
+	memcpy(buffer, buf, 12);
+} /* end sd_read_true_cap() */
+
  /*
   * read disk capacity
   */
@@ -1070,7 +1176,12 @@
  		
  		sdkp->capacity = 1 + (sector_t) 0xffffffff;		
  		goto got_data;
-	}	
+	}
+
+	/* Check if the device reported CAPACITY as opposed to
+	 * the maxumum LBA (as per the SBC spec).
+	 */
+	sd_read_true_cap(sdkp, diskname, SRpnt, buffer, longrc);
  	
  	if (!longrc) {
  		sector_size = (buffer[4] << 24) |
@@ -1078,12 +1189,14 @@
  		if (buffer[0] == 0xff && buffer[1] == 0xff &&
  		    buffer[2] == 0xff && buffer[3] == 0xff) {
  			if(sizeof(sdkp->capacity) > 4) {
-				printk(KERN_NOTICE "%s : very big device. try to use"
-				       " READ CAPACITY(16).\n", diskname);
+				printk(KERN_NOTICE "%s : very big device. "
+				       "try to use READ CAPACITY(16).\n",
+				       diskname);
  				longrc = 1;
  				goto repeat;
  			} else {
-				printk(KERN_ERR "%s: too big for kernel.  Assuming maximum 2Tb\n", diskname);
+				printk(KERN_ERR "%s: too big for kernel. "
+				       "Assuming maximum 2Tb\n", diskname);
  			}
  		}
  		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
@@ -1102,7 +1215,7 @@
  			
  		sector_size = (buffer[8] << 24) |
  			(buffer[9] << 16) | (buffer[10] << 8) | buffer[11];
-	}	
+	}

  got_data:
  	if (sector_size == 0) {

--------------030809010505060400050904
Content-Type: application/octet-stream;
 name="sd_read_cap.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sd_read_cap.patch"

PT09PT0gZHJpdmVycy9zY3NpL3NkLmMgMS4xNjEgdnMgZWRpdGVkID09PT09Ci0tLSAxLjE2
MS9kcml2ZXJzL3Njc2kvc2QuYwkyMDA0LTEwLTE1IDEwOjQ2OjA3IC0wNDowMAorKysgZWRp
dGVkL2RyaXZlcnMvc2NzaS9zZC5jCTIwMDQtMTAtMTkgMTY6NTE6NDYgLTA0OjAwCkBAIC05
ODcsNiArOTg3LDExMiBAQAogCX0KIH0KIAorLyogc2RfcmVhZF90cnVlX2NhcDogU29tZSBk
ZXZpY2Ugc2VydmVycyBpbmNvcnJlY3RseSByZXR1cm4gdGhlCisgKiBjYXBhY2l0eSBhcyBv
cHBvc2VkIHRvIHRoZSBMQkEgb2YgdGhlIGxhc3QgbG9naWNhbCBibG9jayBvZiB0aGUKKyAq
IGJsb2NrIGRldmljZS4KKyAqCisgKiBXZSB0cnkgdG8gZml4IHRoaXMgYXMgZm9sbG93czog
TGV0IHggPSBSZXR1cm5lZCBMQkEgZnJvbSB0aGUgbGFzdAorICogUkVBRCBDQVBBQ0lUWSBj
b21tYW5kIGlzc3VlZCAocmVzdWx0IGluICJidWZmZXIiKS4gIFJlaXNzdWUgdGhlCisgKiBS
RUFEIENBUEFDSVRZIGNvbW1hbmQgYXMgZm9sbG93czogc2V0IHRoZSBwYXJ0aWFsIG1lZGl1
bSBpbmRpY2F0b3IKKyAqIChQTUkpIGJpdCB0byBvbmU7IHNldCB0aGUgTEJBIHRvIHggLSAx
LiBGaXJlIG9mZiB0aGF0IFJFQUQgQ0FQQUNJVFkKKyAqIGNvbW1hbmQuCisgKgorICogSWYg
d2UgZ2V0IHN1Y2Nlc3MsCisgKiAgICAgICBJZiBSZXR1cm5lZCBMQkEgPiB4IC0gMSwgdGhl
biBjYXBhY2l0eSBpcyB4KzEsIHNwZWMgYmVoYXZpb3IuCisgKiAgICAgICBFbHNlIFJldHVy
bmVkIExCQSA8PSB4IC0gMSwgdGhlbiBjYXBhY2l0eSBpcyB4LCBicm9rZW4gZGV2aWNlIHNl
cnZlci4KKyAqIEVsc2UgZXJyb3IsIG5vdGhpbmcgY2FuIGJlIGFzc3VtZWQsIGNhcGFjaXR5
IGlzIHgrMS4KKyAqLworI2RlZmluZSBHRVRfUkxCQV9SRUFEX0NBUDE2KF9idWZmZXIpICgo
KHU2NCkoX2J1ZmZlcilbMF0gPDwgNTYpIHwgXAorCQkJCSAgICAgKCh1NjQpKF9idWZmZXIp
WzFdIDw8IDQ4KSB8ICBcCisJCQkJICAgICAoKHU2NCkoX2J1ZmZlcilbMl0gPDwgNDApIHwg
IFwKKwkJCQkgICAgICgodTY0KShfYnVmZmVyKVszXSA8PCAzMikgfCAgXAorCQkJCSAgICAg
KChzZWN0b3JfdCkoX2J1ZmZlcilbNF0gPDwgMjQpIHwgXAorCQkJCSAgICAgKChzZWN0b3Jf
dCkoX2J1ZmZlcilbNV0gPDwgMTYpIHwgXAorCQkJCSAgICAgKChzZWN0b3JfdCkoX2J1ZmZl
cilbNl0gPDwgOCkgIHwgXAorCQkJCSAgICAgKHNlY3Rvcl90KShfYnVmZmVyKVs3XSkKKyNk
ZWZpbmUgR0VUX1JMQkFfUkVBRF9DQVAxMChfYnVmZmVyKSAoKChzZWN0b3JfdCkoX2J1ZmZl
cilbMF0gPDwgMjQpIHwgXAorCQkJCSAgICAgICgoX2J1ZmZlcilbMV0gPDwgMTYpIHwgICAg
ICAgICAgIFwKKwkJCQkgICAgICAoKF9idWZmZXIpWzJdIDw8IDgpIHwgICAgICAgICAgICBc
CisJCQkJICAgICAgKF9idWZmZXIpWzNdKQorc3RhdGljIHZvaWQgc2RfcmVhZF90cnVlX2Nh
cChzdHJ1Y3Qgc2NzaV9kaXNrICpzZCwgY2hhciAqZGlza25hbWUsCisJCQkgICAgIHN0cnVj
dCBzY3NpX3JlcXVlc3QgKlNScG50LCB1bnNpZ25lZCBjaGFyICpidWZmZXIsCisJCQkgICAg
IGludCBsb25ncmMpCit7CisJdW5zaWduZWQgY2hhciBjbWRbMTZdOworCXVuc2lnbmVkIGNo
YXIgYnVmWzEyXTsKKworCS8qIHNhdmUgdGhlIG9sZCBidWZmZXIgY29udGVudHMgaGVyZSAq
LworCW1lbWNweShidWYsIGJ1ZmZlciwgMTIpOworCisJaWYgKGxvbmdyYykgeworCQl1NjQg
KmxiYSA9ICh1NjQgKikgKGNtZCsyKTsKKwkJdTY0IHJsYmE7CisKKwkJbWVtc2V0KCh2b2lk
ICopIGNtZCwgMCwgMTYpOworCQljbWRbMF0gPSBTRVJWSUNFX0FDVElPTl9JTjsKKwkJY21k
WzFdID0gU0FJX1JFQURfQ0FQQUNJVFlfMTY7CisJCWNtZFsxM10gPSAxMjsKKworCQlybGJh
ID0gR0VUX1JMQkFfUkVBRF9DQVAxNihidWZmZXIpOworCQlybGJhIC09IDE7CisJCSpsYmEg
PSBjcHVfdG9fYmU2NChybGJhKTsKKwkJLyogdHVybiBvbiB0aGUgUE1JIGJpdCAqLworCQlj
bWRbMTRdIHw9IDE7CisJCW1lbXNldCgodm9pZCAqKSBidWZmZXIsIDAsIDEyKTsKKwl9IGVs
c2UgeworCQl1MzIgKmxiYSA9ICh1MzIgKikgKGNtZCsyKTsKKwkJdTMyIHJsYmE7CisKKwkJ
Y21kWzBdID0gUkVBRF9DQVBBQ0lUWTsKKwkJbWVtc2V0KCh2b2lkICopICZjbWRbMV0sIDAs
IDkpOworCQkKKwkJcmxiYSA9IEdFVF9STEJBX1JFQURfQ0FQMTAoYnVmZmVyKTsKKwkJcmxi
YSAtPSAxOworCQkqbGJhID0gY3B1X3RvX2JlMzIocmxiYSk7CisJCS8qIHR1cm4gb24gdGhl
IFBNSSBiaXQgKi8KKwkJY21kWzhdIHw9IDE7CisJCW1lbXNldCgodm9pZCAqKSBidWZmZXIs
IDAsIDgpOworCX0KKworCVNScG50LT5zcl9jbWRfbGVuID0gMDsKKwlTUnBudC0+c3Jfc2Vu
c2VfYnVmZmVyWzBdID0gMDsKKwlTUnBudC0+c3Jfc2Vuc2VfYnVmZmVyWzJdID0gMDsKKwlT
UnBudC0+c3JfZGF0YV9kaXJlY3Rpb24gPSBETUFfRlJPTV9ERVZJQ0U7CisJCisJc2NzaV93
YWl0X3JlcShTUnBudCwgKHZvaWQgKikgY21kLCAodm9pZCAqKSBidWZmZXIsCisJCSAgICAg
IGxvbmdyYyA/IDEyIDogOCwgU0RfVElNRU9VVCwgU0RfTUFYX1JFVFJJRVMpOworCisJaWYg
KFNScG50LT5zcl9yZXN1bHQpIHsKKwkJLyogTm90aGluZyBjYW4gYmUgYXNzdW1lZC4gKi8K
KwkJcHJpbnRrKEtFUk5fTk9USUNFICIlczogJXM6IFBNSSBub3Qgc3VwcG9ydGVkXG4iLAor
CQkgICAgICAgX19GVU5DVElPTl9fLCBkaXNrbmFtZSk7CisJCW1lbWNweShidWZmZXIsIGJ1
ZiwgMTIpOworCQlyZXR1cm47CisJfQorCisJaWYgKGxvbmdyYykgeworCQl1NjQgcmxiYSA9
IEdFVF9STEJBX1JFQURfQ0FQMTYoYnVmZmVyKTsKKwkJdTY0IHggICAgPSBHRVRfUkxCQV9S
RUFEX0NBUDE2KGJ1Zik7CisJCWlmIChybGJhID4geCAtIDEpIHsKKwkJCWdvdG8gb3V0X3Nw
ZWM7CisJCX0KKwl9IGVsc2UgeworCQl1MzIgcmxiYSA9IEdFVF9STEJBX1JFQURfQ0FQMTAo
YnVmZmVyKTsKKwkJdTMyIHggICAgPSBHRVRfUkxCQV9SRUFEX0NBUDEwKGJ1Zik7CisJCWlm
IChybGJhID4geCAtIDEpIHsKKwkJCWdvdG8gb3V0X3NwZWM7CisJCX0KKwl9CisJcHJpbnRr
KEtFUk5fTk9USUNFICIlczogJXM6IGJyb2tlbiBkZXZpY2Ugc2VydmVyXG4iLCBfX0ZVTkNU
SU9OX18sCisJICAgICAgIGRpc2tuYW1lKTsKKwlyZXR1cm47CisJCisgb3V0X3NwZWM6CisJ
LyogQ2FwYWNpdHkgaXMgeCsxLCBzcGVjIGJlaGF2aW9yLiAqLworCXByaW50ayhLRVJOX05P
VElDRSAiJXM6ICVzOiBzcGVjIGJlaGF2aW9yXG4iLCBfX0ZVTkNUSU9OX18sIGRpc2tuYW1l
KTsKKwltZW1jcHkoYnVmZmVyLCBidWYsIDEyKTsKK30gLyogZW5kIHNkX3JlYWRfdHJ1ZV9j
YXAoKSAqLworCiAvKgogICogcmVhZCBkaXNrIGNhcGFjaXR5CiAgKi8KQEAgLTEwNzAsNyAr
MTE3NiwxMiBAQAogCQkKIAkJc2RrcC0+Y2FwYWNpdHkgPSAxICsgKHNlY3Rvcl90KSAweGZm
ZmZmZmZmOwkJCiAJCWdvdG8gZ290X2RhdGE7Ci0JfQkKKwl9CisKKwkvKiBDaGVjayBpZiB0
aGUgZGV2aWNlIHJlcG9ydGVkIENBUEFDSVRZIGFzIG9wcG9zZWQgdG8KKwkgKiB0aGUgbWF4
dW11bSBMQkEgKGFzIHBlciB0aGUgU0JDIHNwZWMpLgorCSAqLworCXNkX3JlYWRfdHJ1ZV9j
YXAoc2RrcCwgZGlza25hbWUsIFNScG50LCBidWZmZXIsIGxvbmdyYyk7CiAJCiAJaWYgKCFs
b25ncmMpIHsKIAkJc2VjdG9yX3NpemUgPSAoYnVmZmVyWzRdIDw8IDI0KSB8CkBAIC0xMDc4
LDEyICsxMTg5LDE0IEBACiAJCWlmIChidWZmZXJbMF0gPT0gMHhmZiAmJiBidWZmZXJbMV0g
PT0gMHhmZiAmJgogCQkgICAgYnVmZmVyWzJdID09IDB4ZmYgJiYgYnVmZmVyWzNdID09IDB4
ZmYpIHsKIAkJCWlmKHNpemVvZihzZGtwLT5jYXBhY2l0eSkgPiA0KSB7Ci0JCQkJcHJpbnRr
KEtFUk5fTk9USUNFICIlcyA6IHZlcnkgYmlnIGRldmljZS4gdHJ5IHRvIHVzZSIKLQkJCQkg
ICAgICAgIiBSRUFEIENBUEFDSVRZKDE2KS5cbiIsIGRpc2tuYW1lKTsKKwkJCQlwcmludGso
S0VSTl9OT1RJQ0UgIiVzIDogdmVyeSBiaWcgZGV2aWNlLiAiCisJCQkJICAgICAgICJ0cnkg
dG8gdXNlIFJFQUQgQ0FQQUNJVFkoMTYpLlxuIiwKKwkJCQkgICAgICAgZGlza25hbWUpOwog
CQkJCWxvbmdyYyA9IDE7CiAJCQkJZ290byByZXBlYXQ7CiAJCQl9IGVsc2UgewotCQkJCXBy
aW50ayhLRVJOX0VSUiAiJXM6IHRvbyBiaWcgZm9yIGtlcm5lbC4gIEFzc3VtaW5nIG1heGlt
dW0gMlRiXG4iLCBkaXNrbmFtZSk7CisJCQkJcHJpbnRrKEtFUk5fRVJSICIlczogdG9vIGJp
ZyBmb3Iga2VybmVsLiAiCisJCQkJICAgICAgICJBc3N1bWluZyBtYXhpbXVtIDJUYlxuIiwg
ZGlza25hbWUpOwogCQkJfQogCQl9CiAJCXNka3AtPmNhcGFjaXR5ID0gMSArICgoKHNlY3Rv
cl90KWJ1ZmZlclswXSA8PCAyNCkgfApAQCAtMTEwMiw3ICsxMjE1LDcgQEAKIAkJCQogCQlz
ZWN0b3Jfc2l6ZSA9IChidWZmZXJbOF0gPDwgMjQpIHwKIAkJCShidWZmZXJbOV0gPDwgMTYp
IHwgKGJ1ZmZlclsxMF0gPDwgOCkgfCBidWZmZXJbMTFdOwotCX0JCisJfQogCiBnb3RfZGF0
YToKIAlpZiAoc2VjdG9yX3NpemUgPT0gMCkgewo=
--------------030809010505060400050904--

