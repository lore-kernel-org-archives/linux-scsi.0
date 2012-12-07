From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 3/9] Introduce scsi_device_being_removed()
Date: Fri, 07 Dec 2012 13:43:24 +0100
Message-ID: <50C1E46C.1020208@acm.org>
References: <50C0BEEE.4040907@acm.org> <50C0BFD5.9030604@acm.org> <e6b81317b8ba62b6493cf67645cb1501@sf-mail.de> <50C1B2DB.9070001@acm.org> <35b212f7c176c6782f048f01fe7e75dd@sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:53363 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964900Ab2LGMn2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 07:43:28 -0500
In-Reply-To: <35b212f7c176c6782f048f01fe7e75dd@sf-mail.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On 12/07/12 11:02, Rolf Eike Beer wrote:
> Am , schrieb Bart Van Assche:
>> On 12/07/12 09:40, Rolf Eike Beer wrote:
>>>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>>>> index 55367b0..767dd16 100644
>>>> --- a/include/scsi/scsi_device.h
>>>> +++ b/include/scsi/scsi_device.h
>>>> @@ -442,6 +442,11 @@ static inline int scsi_device_created(struct
>>>> scsi_device *sdev)
>>>>      return sdev->sdev_state == SDEV_CREATED ||
>>>>          sdev->sdev_state == SDEV_CREATED_BLOCK;
>>>>  }
>>>> +static inline int scsi_device_being_removed(struct scsi_device *sdev)
>>>> +{
>>>> +    return sdev->sdev_state == SDEV_CANCEL ||
>>>> +        sdev->sdev_state == SDEV_DEL;
>>>> +}
>>>>
>>>>  /* accessor functions for the SCSI parameters */
>>>>  static inline int scsi_device_sync(struct scsi_device *sdev)
>>>
>>> Newline missing before the new function.
>>
>> Hello Rolf,
>>
>> Well spotted. Did you realize I had left out the newline on purpose,
>> to preserve consistency with the rest of the header file ?
> 
> Well, there is already a newline between scsi_device_created() and 
> scsi_device_sync() where you insert your stuff so this sort of 
> consistency is hard to spot.

Hello Eike,

So you really care about these blank lines ? How about the patch below ?
It is identical to the patch at the start of this thread except that it
adds a blank line between each pair of functions in <scsi/scsi_device.h>
where there was not yet a blank line.

---
 drivers/scsi/device_handler/scsi_dh.c |    7 ++-----
 include/scsi/scsi_device.h            |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 33e422e..78b3ddb 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -156,8 +156,7 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 	struct scsi_device_handler *scsi_dh;
 	int err = -EINVAL;
 
-	if (sdev->sdev_state == SDEV_CANCEL ||
-	    sdev->sdev_state == SDEV_DEL)
+	if (scsi_device_being_removed(sdev))
 		return -ENODEV;
 
 	if (!sdev->scsi_dh_data) {
@@ -400,9 +399,7 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	if (sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 	dev = get_device(&sdev->sdev_gendev);
-	if (!scsi_dh || !dev ||
-	    sdev->sdev_state == SDEV_CANCEL ||
-	    sdev->sdev_state == SDEV_DEL)
+	if (!scsi_dh || !dev || scsi_device_being_removed(sdev))
 		err = SCSI_DH_NOSYS;
 	if (sdev->sdev_state == SDEV_OFFLINE)
 		err = SCSI_DH_DEV_OFFLINED;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 55367b0..b9b19ca 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -426,54 +426,69 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
 /*
  * checks for positions of the SCSI state machine
  */
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return (sdev->sdev_state != SDEV_OFFLINE &&
 		sdev->sdev_state != SDEV_TRANSPORT_OFFLINE &&
 		sdev->sdev_state != SDEV_DEL);
 }
+
 static inline int scsi_device_blocked(struct scsi_device *sdev)
 {
 	return sdev->sdev_state == SDEV_BLOCK ||
 		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
+
 static inline int scsi_device_created(struct scsi_device *sdev)
 {
 	return sdev->sdev_state == SDEV_CREATED ||
 		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
 
+static inline int scsi_device_being_removed(struct scsi_device *sdev)
+{
+	return sdev->sdev_state == SDEV_CANCEL ||
+		sdev->sdev_state == SDEV_DEL;
+}
+
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
 {
 	return sdev->sdtr;
 }
+
 static inline int scsi_device_wide(struct scsi_device *sdev)
 {
 	return sdev->wdtr;
 }
+
 static inline int scsi_device_dt(struct scsi_device *sdev)
 {
 	return sdev->ppr;
 }
+
 static inline int scsi_device_dt_only(struct scsi_device *sdev)
 {
 	if (sdev->inquiry_len < 57)
 		return 0;
 	return (sdev->inquiry[56] & 0x0c) == 0x04;
 }
+
 static inline int scsi_device_ius(struct scsi_device *sdev)
 {
 	if (sdev->inquiry_len < 57)
 		return 0;
 	return sdev->inquiry[56] & 0x01;
 }
+
 static inline int scsi_device_qas(struct scsi_device *sdev)
 {
 	if (sdev->inquiry_len < 57)
 		return 0;
 	return sdev->inquiry[56] & 0x02;
 }
+
 static inline int scsi_device_enclosure(struct scsi_device *sdev)
 {
 	return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
-- 
1.7.10.4



