From: Sakurai Hiroomi <sakurai_hiro@soft.fujitsu.com>
Subject: [BUG][RFC][PATCH] dpt_i2o driver in 2.4
Date: Tue, 18 Jan 2005 14:41:07 +0900
Message-ID: <0IAH00MIEZN1EF@simsproxy3.soft.fujitsu.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="Boundary_(ID_g0Ovs4FXgpmbXiYSk33C2A)"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:31904 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261237AbVARFhx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 00:37:53 -0500
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id j0I5bpOP001601 for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2005 14:37:51 +0900
	(envelope-from sakurai_hiro@soft.fujitsu.com)
Received: from s5.gw.fujitsu.co.jp by m1.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id j0I5boND020211 for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2005 14:37:50 +0900
	(envelope-from sakurai_hiro@soft.fujitsu.com)
Received: from s5.gw.fujitsu.co.jp (localhost [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 9045130008
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2005 14:37:50 +0900 (JST)
Received: from simsproxy3.soft.fujitsu.com (simsproxy3.soft.fujitsu.com [10.124.20.12])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 54D052FFF7
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2005 14:37:50 +0900 (JST)
Received: from simsproxy2.soft.fujitsu.com ([10.124.103.64])
 by simsproxy3.soft.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0IAH00MICZN0EF@simsproxy3.soft.fujitsu.com> for
 linux-scsi@vger.kernel.org; Tue, 18 Jan 2005 14:37:49 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hiroomi sakurai <sakurai_hiro@soft.fujitsu.com>


--Boundary_(ID_g0Ovs4FXgpmbXiYSk33C2A)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT

Dear Mark,

Our Linux server uses adaptec ASR-2010S and we are using dpt_i2o driver.
To raise the reliability of the server, we reviewd the dpt_i2o driver.
# The version of driver is 2.4 Build 5 in linux-2.4.28.

We found some problems and questions.

Please see the attached the dpt_i2o_problem_document.txt about the problems. 
And also I made a patch agains the driver(dpt_i2o.diff).

I'm not participated in the linux-scsi mailing list.
Please reply to the following addresses. 

    E-Mail : sakurai_hiro@soft.fujitsu.com

Best Regards
Hiroomi Sakurai


--Boundary_(ID_g0Ovs4FXgpmbXiYSk33C2A)
Content-type: text/plain; name=dpt_i2o_problem_document.txt
Content-disposition: attachment; filename=dpt_i2o_problem_document.txt
Content-transfer-encoding: 7BIT



Please see the dpt_i2o.diff about the correction of each problem.


Problem

1. Problem in adpt_detect() function

   When adpt_install_hba() returns error status, adpt_detect() returns hba_count-1.
   But it's necessary to call adpt_i2o_sys_shutdown() and return 0.

   adpt_detect() : 181 - 191
   ----------------------------------------------------------------------------
   /* search for all Adatpec I2O RAID cards */
   while ((pDev = pci_find_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
           if(pDev->device == PCI_DPT_DEVICE_ID ||
              pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
                   if(adpt_install_hba(sht, pDev) ){
                           PERROR("Could not Init an I2O RAID device\n");
                           PERROR("Will not try to detect others.\n");
                           return hba_count-1;
                   }
           }
   }
   ----------------------------------------------------------------------------


2. Problem in adpt_detect() and adpt_inquiry() function

   adpt_inquiry() doesn't return any value even if it detects any errors.
   Please add error status as a return value.
   When caller receives error from adpt_inquiry(), caller should check the
   return value.
   For example, when adpt_detect() receives error status, it should check
   the value.

   adpt_detect() : 238 - 242
   ----------------------------------------------------------------------------
   if (adpt_i2o_parse_lct(pHba) < 0){
           adpt_i2o_delete_hba(pHba);
           continue;
   }
   adpt_inquiry(pHba);
   ----------------------------------------------------------------------------

   adpt_inquiry() : 277 - 355
   ----------------------------------------------------------------------------
   static void adpt_inquiry(adpt_hba* pHba)
   {

   (omission)

   }
   ----------------------------------------------------------------------------


3. Problem in adpt_proc_info() function

   adpt_proc_info() doesn't check 'd->pScsi_dev' is null or not.
   It cause panic when 'd->pScsi_dev' is null.
   It is necessary to check it.

   adpt_proc_info() : 577 - 583
   ----------------------------------------------------------------------------
   for(chan = 0; chan < MAX_CHANNEL; chan++) {
           for(id = 0; id < MAX_ID; id++) {
                   d = pHba->channel[chan].device[id];
                   while(d){
                           len += sprintf(buffer+len,"\t%-24.24s", d->pScsi_dev->vendor);
                           len += sprintf(buffer+len," Rev: %-8.8s\n", d->pScsi_dev->rev);
                           pos = begin + len;
   ----------------------------------------------------------------------------


4. Problem in adpt_install_hba() function

   adpt_install_hba() find the emplty hbas[i] by 'for (i=0;i<DPTI_MAX_HBA;i++)'.
   But even if there are no emply hbas[], it continues the operaiton.
   This causes device name 'dpti16' for all devices exceeds 17 cards.
   You should remove the limitation of card number(DPTI_MAX_HBA=16).
   (At least you should add the error sequence to fail exceeds 17.)

   adpt_install_hba() : 929 - 934
   ----------------------------------------------------------------------------
   for(i=0;i<DPTI_MAX_HBA;i++) {
           if(hbas[i]==NULL) {
                   hbas[i]=pHba;
                   break;
           }
   }
   ----------------------------------------------------------------------------


5. Problem in adpt_find_device() function

   In adpt_find_device(), you should check 'id' is smaller than 'MAX_ID'.

   adpt_find_device() : 1087 - 1088
   ----------------------------------------------------------------------------
   if(chan < 0 || chan >= MAX_CHANNEL)
           return NULL;
   ----------------------------------------------------------------------------


6. Problem in adpt_i2o_reparse_lct() function

   In adpt_i2o_reparse_lct(), you check 'bus_no' is smaller than 'MAX_CHANNEL',
   but you use 'bus_no' before checking.
   You should move the sequence of checking before using.
   Also you should check the check 'scsi_id' is smaller than 'MAX_ID'.

   adpt_i2o_reparse_lct() : 2410 - 2442
   ----------------------------------------------------------------------------
   bus_no = buf[0]>>16;
   scsi_id = buf[1];
   scsi_lun = (buf[2]>>8 )&0xff;
   pDev = pHba->channel[bus_no].device[scsi_id];

   (omission)

   if(bus_no >= MAX_CHANNEL) {     // Something wrong skip it
           printk(KERN_WARNING"%s: Channel number %d out of range \n", pHba->name, bus_no);
           continue;
   }
   pDev = pHba->channel[bus_no].device[scsi_id];
   ----------------------------------------------------------------------------


7. Problem in adpt_i2o_reparse_lct() function

   In adpt_i2o_reparse_lct(), you check 'pDev->pScsi_dev' is null or not, 
   but you use 'pDev->pScsi_dev' before checking.
   You shoud move the sequence ot checking before using.

   adpt_i2o_reparse_lct() : 2480 - 2486
   ----------------------------------------------------------------------------
   if(pDev->pScsi_dev->online == FALSE) {
           printk(KERN_WARNING"%s: Setting device (%d,%d,%d) back online\n",
                           pHba->name,bus_no,scsi_id,scsi_lun);
           if (pDev->pScsi_dev) {
                   pDev->pScsi_dev->online = TRUE;
           }
   }
   ----------------------------------------------------------------------------


8. Problem in adpt_i2o_lct_get() function

   adpt_i2o_lct_get() continues the operation even of adpt_i2o_query_scalar()
   returns with error status.
   It's necessary return -1 when error detects.

   adpt_i2o_lct_get() : 2924 - 2936
   ----------------------------------------------------------------------------
   // I2O_DPT_EXEC_IOP_BUFFERS_GROUP_NO;
   if(adpt_i2o_query_scalar(pHba, 0 , 0x8000, -1, buf, sizeof(buf))>=0) {
           pHba->FwDebugBufferSize = buf[1];
           pHba->FwDebugBuffer_P    = pHba->base_addr_virt + buf[0];
           pHba->FwDebugFlags_P     = pHba->FwDebugBuffer_P + FW_DEBUG_FLAGS_OFFSET;
           pHba->FwDebugBLEDvalue_P = pHba->FwDebugBuffer_P + FW_DEBUG_BLED_OFFSET;
           pHba->FwDebugBLEDflag_P  = pHba->FwDebugBLEDvalue_P + 1;
           pHba->FwDebugStrLength_P = pHba->FwDebugBuffer_P + FW_DEBUG_STR_LENGTH_OFFSET;
           pHba->FwDebugBuffer_P += buf[2];
           pHba->FwDebugFlags = 0;
   }

   return 0;
   ----------------------------------------------------------------------------


Question

1. Question in adpt_queue() function

   In adpt_queue(), you check 'cmd->device->hostdata' is null or not every
   time. But this sequence seems redundant.
   I think this operation can move in adpt_detect().
   'pDev->pScsi_dev=cmd->device' aslo seems redundant.


   adpt_queue() : 422 - 439
   ----------------------------------------------------------------------------
   // TODO if the cmd->device if offline then I may need to issue a bus rescan
   // followed by a get_lct to see if the device is there anymore
   if((pDev = (struct adpt_device*) (cmd->device->hostdata)) == NULL) {
           /*
            * First command request for this device.  Set up a pointer
            * to the device structure.  This should be a TEST_UNIT_READY
            * command from scan_scsis_single.
            */
           if ((pDev = adpt_find_device(pHba, (u32)cmd->channel, (u32)cmd->target, (u32)cmd-> lun)) == NULL) {
                   // TODO: if any luns are at this bus, scsi id then fake a TEST_UNIT_READY and INQUIRY response
                   // with type 7F (for all luns less than the max for this bus,id) so the lun scan will continue.
                   cmd->result = (DID_NO_CONNECT << 16);
                   cmd->scsi_done(cmd);
                   return 0;
           }
           (struct adpt_device*)(cmd->device->hostdata) = pDev;
   }
   pDev->pScsi_dev = cmd->device;
   ----------------------------------------------------------------------------


2. Question in adpt_i2o_to_scsi() function

   Why adpt_i2o_to_scsi() returns DID_TIMEOUT when sense code is
   DATA_PROTECT and 'class 7'?


   adpt_i2o_to_scsi() : 2306 - 2322
   ----------------------------------------------------------------------------
   // copy over the request sense data if it was a check
   // condition status
   if(dev_status == 0x02 /*CHECK_CONDITION*/) {
           u32 len = sizeof(cmd->sense_buffer);
           len = (len > 40) ?  40 : len;
           // Copy over the sense data
           memcpy(cmd->sense_buffer, (void*)(reply+28) , len);
           if(cmd->sense_buffer[0] == 0x70 /* class 7 */ &&
              cmd->sense_buffer[2] == DATA_PROTECT ){
                   /* This is to handle an array failed */
                   cmd->result = (DID_TIME_OUT << 16);
                   printk(KERN_WARNING"%s: SCSI Data Protect-Device (%d,%d,%d) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
                           pHba->name, (u32)cmd->channel, (u32)cmd->target, (u32)cmd->lun,
                           hba_status, dev_status, cmd->cmnd[0]);

            }
   }
   ----------------------------------------------------------------------------


3. Question in adpt_i2o_build_sys_table() function

   adpt_i2o_build_systable() continues the operation even if adpt_i2o_status_get()
   returns the error. This cause the diferrence between the number of actual HBAs(hba_count) and
   and the number of sys_tbl entry(sys_tbl->num_entries).
   Does this cause some kind of problem?

   adpt_i2o_build_sys_table() : 2961 - 2981
   ----------------------------------------------------------------------------
   for(pHba = hba_chain; pHba; pHba = pHba->next) {
           // Get updated Status Block so we have the latest information
           if (adpt_i2o_status_get(pHba)) {
                   sys_tbl->num_entries--;
                   continue; // try next one
           }

           sys_tbl->iops[count].org_id = pHba->status_block->org_id;
           sys_tbl->iops[count].iop_id = pHba->unit + 2;
           sys_tbl->iops[count].seg_num = 0;
           sys_tbl->iops[count].i2o_version = pHba->status_block->i2o_version;
           sys_tbl->iops[count].iop_state = pHba->status_block->iop_state;
           sys_tbl->iops[count].msg_type = pHba->status_block->msg_type;
           sys_tbl->iops[count].frame_size = pHba->status_block->inbound_frame_size;
           sys_tbl->iops[count].last_changed = sys_tbl_ind - 1; // ??
           sys_tbl->iops[count].iop_capabilities = pHba->status_block->iop_capabilities;
           sys_tbl->iops[count].inbound_low = (u32)virt_to_bus((void*)pHba->post_port);
           sys_tbl->iops[count].inbound_high = (u32)((u64)virt_to_bus((void*)pHba->post_port)>>32);

           count++;
   }
   ----------------------------------------------------------------------------



--Boundary_(ID_g0Ovs4FXgpmbXiYSk33C2A)
Content-type: application/octet-stream; name=dpt_i2o.diff
Content-disposition: attachment; filename=dpt_i2o.diff
Content-transfer-encoding: base64

ZGlmZiAtTnVyIGxpbnV4LTIuNC4yOC5vcmcvZHJpdmVycy9zY3NpL2RwdF9pMm8uYyBsaW51
eC0yLjQuMjgvZHJpdmVycy9zY3NpL2RwdF9pMm8uYwotLS0gbGludXgtMi40LjI4Lm9yZy9k
cml2ZXJzL3Njc2kvZHB0X2kyby5jCTIwMDQtMTEtMTcgMjA6NTQ6MjEuMDAwMDAwMDAwICsw
OTAwCisrKyBsaW51eC0yLjQuMjgvZHJpdmVycy9zY3NpL2RwdF9pMm8uYwkyMDA1LTAxLTE4
IDExOjQyOjU2LjAwMDAwMDAwMCArMDkwMAoKLyogICAgICAgICAgICAgICAgICAqLwovKiBQ
cm9ibGVtIE51bWJlciAxICovCi8qICAgICAgICAgICAgICAgICAgKi8KKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqCkBAIC0xODUsNyArMTg1LDggQEAKIAkJCWlmKGFkcHRfaW5z
dGFsbF9oYmEoc2h0LCBwRGV2KSApewogCQkJCVBFUlJPUigiQ291bGQgbm90IEluaXQgYW4g
STJPIFJBSUQgZGV2aWNlXG4iKTsKIAkJCQlQRVJST1IoIldpbGwgbm90IHRyeSB0byBkZXRl
Y3Qgb3RoZXJzLlxuIik7Ci0JCQkJcmV0dXJuIGhiYV9jb3VudC0xOworCQkJCWFkcHRfaTJv
X3N5c19zaHV0ZG93bigpOworCQkJCXJldHVybiAwOwogCQkJfQogCQl9CiAJfQoqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioKCi8qICAgICAgICAgICAgICAgICAgKi8KLyogUHJv
YmxlbSBOdW1iZXIgMiAqLwovKiAgICAgICAgICAgICAgICAgICovCioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKgpAQCAtMjM5LDcgKzI0MCwxMSBAQAogCQkJYWRwdF9pMm9fZGVs
ZXRlX2hiYShwSGJhKTsKIAkJCWNvbnRpbnVlOwogCQl9Ci0JCWFkcHRfaW5xdWlyeShwSGJh
KTsKKworCQlpZiAoYWRwdF9pbnF1aXJ5KHBIYmEpIDwgMCkgeworCQkJYWRwdF9pMm9fc3lz
X3NodXRkb3duKCk7CisJCQlyZXR1cm4gMDsKKwkJfQogCX0KIAogCWZvciAocEhiYSA9IGhi
YV9jaGFpbjsgcEhiYTsgcEhiYSA9IHBIYmEtPm5leHQpIHsKQEAgLTI3NCw3ICsyNzksNyBA
QAogfQogCiAKLXN0YXRpYyB2b2lkIGFkcHRfaW5xdWlyeShhZHB0X2hiYSogcEhiYSkKK3N0
YXRpYyBpbnQgYWRwdF9pbnF1aXJ5KGFkcHRfaGJhKiBwSGJhKQogewogCXUzMiBtc2dbMTRd
OyAKIAl1MzIgKm1wdHI7CkBAIC0yOTEsNyArMjk2LDcgQEAKIAlidWYgPSAodTgqKWttYWxs
b2MoODAsR0ZQX0tFUk5FTHxBRERSMzIpOwogCWlmKCFidWYpewogCQlwcmludGsoS0VSTl9F
UlIiJXM6IENvdWxkIG5vdCBhbGxvY2F0ZSBidWZmZXJcbiIscEhiYS0+bmFtZSk7Ci0JCXJl
dHVybjsKKwkJcmV0dXJuIC0xOwogCX0KIAltZW1zZXQoKHZvaWQqKWJ1ZiwgMCwgMzYpOwog
CQpAQCAtMzUxLDcgKzM1Niw3IEBACiAJfQogCWtmcmVlKGJ1Zik7CiAJYWRwdF9pMm9fc3Rh
dHVzX2dldChwSGJhKTsKLQlyZXR1cm4gOworCXJldHVybiAwOwogfQoqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioKIAovKiAgICAgICAgICAgICAgICAgICovCi8qIFByb2JsZW0g
TnVtYmVyIDMgKi8KLyogICAgICAgICAgICAgICAgICAqLwoqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioKQEAgLTU3OCw2ICs1ODMsMTEgQEAKIAkJZm9yKGlkID0gMDsgaWQgPCBN
QVhfSUQ7IGlkKyspIHsKIAkJCWQgPSBwSGJhLT5jaGFubmVsW2NoYW5dLmRldmljZVtpZF07
CiAJCQl3aGlsZShkKXsKKwkJCQlpZiAoZC0+cFNjc2lfZGV2ID09IE5VTEwpIHsKKwkJCQkJ
ZCA9IGQtPm5leHRfbHVuOworCQkJCQljb250aW51ZTsKKwkJCQl9CisKIAkJCQlsZW4gKz0g
c3ByaW50ZihidWZmZXIrbGVuLCJcdCUtMjQuMjRzIiwgZC0+cFNjc2lfZGV2LT52ZW5kb3Ip
OwogCQkJCWxlbiArPSBzcHJpbnRmKGJ1ZmZlcitsZW4sIiBSZXY6ICUtOC44c1xuIiwgZC0+
cFNjc2lfZGV2LT5yZXYpOwogCQkJCXBvcyA9IGJlZ2luICsgbGVuOwoqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioKCi8qICAgICAgICAgICAgICAgICAgKi8KLyogUHJvYmxlbSBO
dW1iZXIgNCAqLwovKiAgICAgICAgICAgICAgICAgICovCioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKgpAQCAtOTMzLDYgKzk0MywxMSBAQAogCQl9CiAJfQogCisJaWYoaSA+PSBE
UFRJX01BWF9IQkEpeworCQlwcmludGsoS0VSTl9FUlIiQ291bGRuJ3QgcmVnaXN0ZXIgZm9y
IGhiYXNbXVxuIik7CisJCXJldHVybiAtRUlOVkFMOworCX0KKwogCWlmKGhiYV9jaGFpbiAh
PSBOVUxMKXsKIAkJZm9yKHAgPSBoYmFfY2hhaW47IHAtPm5leHQ7IHAgPSBwLT5uZXh0KTsK
IAkJcC0+bmV4dCA9IHBIYmE7CioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgoKLyog
ICAgICAgICAgICAgICAgICAqLwovKiBQcm9ibGVtIE51bWJlciA1ICovCi8qICAgICAgICAg
ICAgICAgICAgKi8KKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCkBAIC0xMDkyLDYg
KzExMDcsOSBAQAogCQlyZXR1cm4gTlVMTDsKIAl9CiAKKwlpZiAoaWQgPCAwIHx8IGlkID49
IE1BWF9JRCkKKwkJcmV0dXJuIE5VTEw7CisKIAlkID0gcEhiYS0+Y2hhbm5lbFtjaGFuXS5k
ZXZpY2VbaWRdOwogCWlmKCFkIHx8IGQtPnRpZCA9PSAwKSB7CiAJCXJldHVybiBOVUxMOwoq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioKCi8qICAgICAgICAgICAgICAgICAgKi8K
LyogUHJvYmxlbSBOdW1iZXIgNiAqLwovKiAgICAgICAgICAgICAgICAgICovCioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKgpAQCAtMjQxMCw2ICsyNDI4LDE0IEBACiAJCQlidXNf
bm8gPSBidWZbMF0+PjE2OwogCQkJc2NzaV9pZCA9IGJ1ZlsxXTsKIAkJCXNjc2lfbHVuID0g
KGJ1ZlsyXT4+OCApJjB4ZmY7CisJCQlpZihidXNfbm8gPj0gTUFYX0NIQU5ORUwpIHsgICAg
IC8vIFNvbWV0aGluZyB3cm9uZyBza2lwIGl0CisJCQkJcHJpbnRrKEtFUk5fV0FSTklORyIl
czogQ2hhbm5lbCBudW1iZXIgJWQgb3V0IG9mIHJhbmdlIFxuIiwgcEhiYS0+bmFtZSwgYnVz
X25vKTsKKwkJCQljb250aW51ZTsKKwkJCX0KKwkJCWlmKHNjc2lfaWQgPj0gTUFYX0lEKSB7
CisJCQkJcHJpbnRrKEtFUk5fV0FSTklORyIlczogSWQgbnVtYmVyICVkIG91dCBvZiByYW5n
ZSBcbiIsIHBIYmEtPm5hbWUsIHNjc2lfaWQpOworCQkJCWNvbnRpbnVlOworCQkJfQogCQkJ
cERldiA9IHBIYmEtPmNoYW5uZWxbYnVzX25vXS5kZXZpY2Vbc2NzaV9pZF07CiAJCQkvKiBk
YSBsdW4gKi8KIAkJCXdoaWxlKHBEZXYpIHsKQEAgLTI0MzUsMTAgKzI0NjEsNiBAQAogCQkJ
CWFkcHRfaTJvX3JlcG9ydF9oYmFfdW5pdChwSGJhLCBkKTsKIAkJCQlhZHB0X2kyb19pbnN0
YWxsX2RldmljZShwSGJhLCBkKTsKIAkKLQkJCQlpZihidXNfbm8gPj0gTUFYX0NIQU5ORUwp
IHsJLy8gU29tZXRoaW5nIHdyb25nIHNraXAgaXQKLQkJCQkJcHJpbnRrKEtFUk5fV0FSTklO
RyIlczogQ2hhbm5lbCBudW1iZXIgJWQgb3V0IG9mIHJhbmdlIFxuIiwgcEhiYS0+bmFtZSwg
YnVzX25vKTsKLQkJCQkJY29udGludWU7Ci0JCQkJfQogCQkJCXBEZXYgPSBwSGJhLT5jaGFu
bmVsW2J1c19ub10uZGV2aWNlW3Njc2lfaWRdOwkKIAkJCQlpZiggcERldiA9PSBOVUxMKXsK
IAkJCQkJcERldiA9ICBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgYWRwdF9kZXZpY2UpLEdGUF9L
RVJORUwpOwoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKCi8qICAgICAgICAgICAg
ICAgICAgKi8KLyogUHJvYmxlbSBOdW1iZXIgNyAqLwovKiAgICAgICAgICAgICAgICAgICov
CioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgpAQCAtMjQ3Nyw2ICsyNDk5LDEwIEBA
CiAJCQkvLyBXZSBmb3VuZCBhbiBvbGQgZGV2aWNlIC0gY2hlY2sgaXQKIAkJCXdoaWxlKHBE
ZXYpIHsKIAkJCQlpZihwRGV2LT5zY3NpX2x1biA9PSBzY3NpX2x1bikgeworCQkJCQlpZihw
RGV2LT5wU2NzaV9kZXYgPT0gTlVMTCkgeworCQkJCQkJcERldiA9IHBEZXYtPm5leHRfbHVu
OworCQkJCQkJY29udGludWU7CisJCQkJCX0KIAkJCQkJaWYocERldi0+cFNjc2lfZGV2LT5v
bmxpbmUgPT0gRkFMU0UpIHsKIAkJCQkJCXByaW50ayhLRVJOX1dBUk5JTkciJXM6IFNldHRp
bmcgZGV2aWNlICglZCwlZCwlZCkgYmFjayBvbmxpbmVcbiIsCiAJCQkJCQkJCXBIYmEtPm5h
bWUsYnVzX25vLHNjc2lfaWQsc2NzaV9sdW4pOwoqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioKCi8qICAgICAgICAgICAgICAgICAgKi8KLyogUHJvYmxlbSBOdW1iZXIgOCAqLwov
KiAgICAgICAgICAgICAgICAgICovCioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgpA
QCAtMjkzMSw2ICsyOTU3LDggQEAKIAkJcEhiYS0+RndEZWJ1Z1N0ckxlbmd0aF9QID0gcEhi
YS0+RndEZWJ1Z0J1ZmZlcl9QICsgRldfREVCVUdfU1RSX0xFTkdUSF9PRkZTRVQ7CiAJCXBI
YmEtPkZ3RGVidWdCdWZmZXJfUCArPSBidWZbMl07IAogCQlwSGJhLT5Gd0RlYnVnRmxhZ3Mg
PSAwOworCX0gZWxzZSB7CisJCXJldHVybiAtMTsKIAl9CiAKIAlyZXR1cm4gMDsKKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqCgpkaWZmIC1OdXIgbGludXgtMi40LjI4Lm9yZy9k
cml2ZXJzL3Njc2kvZHB0aS5oIGxpbnV4LTIuNC4yOC9kcml2ZXJzL3Njc2kvZHB0aS5oCi0t
LSBsaW51eC0yLjQuMjgub3JnL2RyaXZlcnMvc2NzaS9kcHRpLmgJMjAwMS0wOS0wOCAwMToy
ODozOC4wMDAwMDAwMDAgKzA5MDAKKysrIGxpbnV4LTIuNC4yOC9kcml2ZXJzL3Njc2kvZHB0
aS5oCTIwMDUtMDEtMTggMTE6NDM6NDYuMDAwMDAwMDAwICswOTAwCgovKiAgICAgICAgICAg
ICAgICAgICovCi8qIFByb2JsZW0gTnVtYmVyIDIgKi8KLyogICAgICAgICAgICAgICAgICAq
LwoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKQEAgLTM0OCw3ICszNDgsNyBAQAog
c3RhdGljIHMzMiBhZHB0X3NlbmRfbm9wKGFkcHRfaGJhKnBIYmEsdTMyIG0pOwogc3RhdGlj
IHZvaWQgYWRwdF9pMm9fZGVsZXRlX2hiYShhZHB0X2hiYSogcEhiYSk7CiBzdGF0aWMgdm9p
ZCBhZHB0X3NlbGVjdF9xdWV1ZV9kZXB0aHMoc3RydWN0IFNjc2lfSG9zdCAqaG9zdCwgU2Nz
aV9EZXZpY2UgKiBkZXZpY2VsaXN0KTsKLXN0YXRpYyB2b2lkIGFkcHRfaW5xdWlyeShhZHB0
X2hiYSogcEhiYSk7CitzdGF0aWMgaW50IGFkcHRfaW5xdWlyeShhZHB0X2hiYSogcEhiYSk7
CiBzdGF0aWMgdm9pZCBhZHB0X2ZhaWxfcG9zdGVkX3NjYnMoYWRwdF9oYmEqIHBIYmEpOwog
c3RhdGljIHN0cnVjdCBhZHB0X2RldmljZSogYWRwdF9maW5kX2RldmljZShhZHB0X2hiYSog
cEhiYSwgdTMyIGNoYW4sIHUzMiBpZCwgdTMyIGx1bik7CiBzdGF0aWMgaW50IGFkcHRfaW5z
dGFsbF9oYmEoU2NzaV9Ib3N0X1RlbXBsYXRlKiBzaHQsIHN0cnVjdCBwY2lfZGV2KiBwRGV2
KSA7CioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgo=

--Boundary_(ID_g0Ovs4FXgpmbXiYSk33C2A)--
