From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 14:02:53 -0700
Message-ID: <1366837373.1971.28.camel@dabdike>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike>
	 <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de>
	 <5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com>
	 <5177D6C2.6080705@redhat.com> <5177EDB5.5000105@tributary.com>
	 <8D3D17ACE214DC429325B2B98F3AE71293F3BBE2@MX15A.corp.emc.com>
	 <5178438F.3010103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58594 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028Ab3DXVC6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 17:02:58 -0400
In-Reply-To: <5178438F.3010103@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: "Black, David" <david.black@emc.com>, Jeremy Linton <jlinton@tributary.com>, Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

On Wed, 2013-04-24 at 16:41 -0400, Ric Wheeler wrote:
> On 04/24/2013 02:20 PM, Black, David wrote:
> > Jeremy,
> >
> > It looks like, you, Paolo and Ric have hit the nail on the head here - this is
> > a nice summary, IMHO:
> >
> >> On 4/24/2013 7:57 AM, Paolo Bonzini wrote:
> >>>> If the device can promise this, we don't care (and don't know) how it
> >>>> manages that promise. It can leave the data on battery backed DRAM, can
> >>> archive it to flash or any other scheme that works.
> >>>
> >>> That's exactly the point of SYNC_NV=1.
> >> 	Well its the point, but the specification is written such that the vendors can
> >> choose to implement it any way they wish, especially for split cache
> >> systems where there is both volatile and non volatile cache.
> > Independent of T10's best intentions at the time, the implementations aren't
> > doing what's needed or intended, and I'd guess that the SYNC_NV bit is not
> > being set to 1 by [other people's ;-) ] software that should be setting it
> > to 1 if it were paying attention to the standard.
> >
> > This is further complicated by it being completely legitimate wrt the SCSI
> > standard to put non-volatile cache in a system and not have the SCSI interface
> > admit that the non-volatile cache exists (WCE=0, SYNCHRONIZE CACHE is a no-op
> > independent of the value of SYNC_NV).
> >
> > I believe that Rob Elliot's 13-050 proposal to obsolete SYNC_NV and re-specify
> > SYNCHRONIZE CACHE to make all data non-volatile by whatever means the target
> > chooses is what T10 should do, and that matches Ric's summary:
> >
> >>>> If the device can promise this, we don't care (and don't know) how it
> >>>> manages that promise. It can leave the data on battery backed DRAM, can
> >>> archive it to flash or any other scheme that works.
> > Beyond that, attempting to manage drive removal from storage systems via the
> > SCSI interface with standard commands is a waste of time and effort, IMHO.
> > In a serious storage array (and even some fairly simple RAID controllers), some
> > vendor-specific "magic" is needed to get the array (or controller) to prepare
> > so that the drive can be removed cleanly.  To oversimplify, it's not enough to
> > flush data to the drive; the array or controller is stateful, and hence has
> > to be told to "forget" the drive, where "forget" involves things that are
> > rather implementation-specific.
> >
> > Thanks,
> > --David
> >
> 
> So I think that leaves us with some arrays that might benefit from Paolo's 
> proposed patch, but almost certainly still will need to be able to "ignore 
> flushes" for some block device accessing DB's, etc....

That just leaves us with random standards behaviour.  Lets permit the
deterministic thing instead for the distros.  It kills two birds with
one stone because we can set WCE for the stupid UAS devices that clear
it wrongly as well.

For those who don't read code well, you add a temporary prefix to the
cache set in

echo xxx > /sys/class/scsi_disk/<disk>/cache_type

and it will set the flags for the lifetime of the current kernel, but
won't try to do a mode select to make them permanent.

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..af16e88 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -142,6 +142,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	const char *temp = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)
@@ -150,6 +151,13 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 		 * it's not worth the risk */
 		return -EINVAL;
 
+	if (strncmp(buf, temp, sizeof(temp) - 1) == 0) {
+		buf += sizeof(temp) - 1;
+		sdkp->cache_override = 1;
+	} else {
+		sdkp->cache_override = 0;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(sd_cache_types); i++) {
 		len = strlen(sd_cache_types[i]);
 		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
@@ -162,6 +170,13 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = ct & 0x02 ? 1 : 0;
+
+	if (sdkp->cache_override) {
+		sdkp->WCE = wce;
+		sdkp->RCD = rcd;
+		return count;
+	}
+
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
 			    SD_MAX_RETRIES, &data, NULL))
 		return -EINVAL;
@@ -2319,6 +2334,10 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
 
+
+	if (sdkp->cache_override)
+		return;
+		
 	first_len = 4;
 	if (sdp->skip_ms_page_8) {
 		if (sdp->type == TYPE_RBC)
@@ -2812,6 +2831,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sdkp->capacity = 0;
 	sdkp->media_present = 1;
 	sdkp->write_prot = 0;
+	sdkp->cache_override = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->ATO = 0;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 74a1e4c..2386aeb 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -73,6 +73,7 @@ struct scsi_disk {
 	u8		protection_type;/* Data Integrity Field */
 	u8		provisioning_mode;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
+	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */


