From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] SCSI: Prevent from retrying with expecting_cc_ua in case
 of disk change.
Date: Thu, 11 Aug 2011 20:25:20 +0900
Message-ID: <4E43BC20.70707@jp.fujitsu.com>
References: <1312378758-17308-1-git-send-email-revers@redhat.com>	 <1312410128.2855.94.camel@mulgrave>  <4E39CC32.70305@cs.wisc.edu>	 <1312410999.2855.97.camel@mulgrave>  <4E40681F.2010306@jp.fujitsu.com> <1312903320.13928.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39114 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab1HKLZU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 07:25:20 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 6C3C13EE0BC
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2011 20:25:18 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 5134245DE5F
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2011 20:25:18 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 2B4C845DE58
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2011 20:25:18 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 12BA21DB8057
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2011 20:25:18 +0900 (JST)
Received: from m025.s.css.fujitsu.com (m025.s.css.fujitsu.com [10.0.81.65])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id C44291DB804F
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2011 20:25:17 +0900 (JST)
In-Reply-To: <1312903320.13928.7.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: michaelc@cs.wisc.edu, revers@redhat.com, linux-scsi@vger.kernel.org

Hi James,

Thanks for your comment.
Actually, Rob and I are focusing to the same problem.
And I have a dvd drive of that kind.

To confirm ASC,ASCQ in this case, I added some printk
like this.
----
        * so that we can deal with it there.
        */
       if (scmd->device->expecting_cc_ua) {
               printk("scsi_check_sense: expecting_cc_ua=on"
                      " unit_attention asc=%02x ascq=%02x\n",
                      sshdr.asc, sshdr.ascq);
               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
               scmd->device->expecting_cc_ua = 0;
               return SCSI_MLQUEUE_DIS_DEV_RETRY;
       }
       /*
        * if the device is in the process of becoming ready, we
        * should retry.
        */
----
And I created boot dvd, booted the system with that in
rescue mode, changed the media after boot and read or write
that media, then, I could see these messages.
----
<6>Adding 4095992k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:4095996k
<4>scsi_check_sense: expecting_cc_ua=on unit_attention asc=28 ascq=00
<4>end_request: I/O error, dev sr0, sector 7432832
----

As message says, my dvd drive reports media change sense and
as the result end_request I/O error is caused.
Surely this drive may be naughty, but we should know what kind of
UA and treat it.


---
 drivers/scsi/scsi_error.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a4b9cdb..158ba46 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -293,8 +293,15 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
                 * so that we can deal with it there.
                 */
                if (scmd->device->expecting_cc_ua) {
-                       scmd->device->expecting_cc_ua = 0;
-                       return NEEDS_RETRY;
+               /*
+                * Because some device does not queue unit attentions correctly,
+                * we carefully check additional sense code and qualifier
+                * so as not to squash media change unit attention.
+                */
+                       if (sshdr.asc != 0x28 || sshdr.ascq != 0x00) {
+                               scmd->device->expecting_cc_ua = 0;
+                               return NEEDS_RETRY;
+                       }
                }
                /*
                 * if the device is in the process of becoming ready, we
--
1.6.5

(2011/08/10 0:22), James Bottomley wrote:
> On Tue, 2011-08-09 at 07:50 +0900, TARUISI Hiroaki wrote:
>> Hi James,
>>
>> I posted a patch (as below) last year about this.
>>   http://www.kerneltrap.org/mailarchive/linux-scsi/2010/12/22/6887895
>>
>> I intended to distinguish UA caused by media change from UA caused by
>> other reasons like resetting a device. First, it should be notified to upper
>> layer driver, sr, but the other must be retried as scsi_error.c coded.
>>
>> At least SCSI driver should not squash all UAs, I think.
> 
> Well ... the spec says the device should stack UAs in this event.
> However, I can totally believe that a broken CD would fail on this
> front.
> 
> If Mike and Rob can verify that it's realy asc/ascq 0x28/0x0 that the CD
> is emitting, I'd be happy to put the patch in (with a nice big comment
> explaining what's being done and why over the if() check rather than
> updating the global comment).
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
-- 
taruisi

