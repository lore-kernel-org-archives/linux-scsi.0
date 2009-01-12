From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Check for deleted device in scsi_device_online()
Date: Mon, 12 Jan 2009 09:28:55 +0100
Message-ID: <496AFF47.3010100@suse.de>
References: <20081216153352.27D4318C75E@pentland.suse.de> <1231432056.3237.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030705000803080804040003"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbZALI25 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 03:28:57 -0500
In-Reply-To: <1231432056.3237.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030705000803080804040003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi James,

James Bottomley wrote:
> On Tue, 2008-12-16 at 16:33 +0100, Hannes Reinecke wrote:
>> scsi_device_online() is not just a negation of SDEV_OFFLINE,
>> also devices in state SDEV_CANCEL and SDEV_DEL are
>> actually offline.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  include/scsi/scsi_device.h |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index e96daf6..63b58d2 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -401,7 +401,9 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
>>   */
>>  static inline int scsi_device_online(struct scsi_device *sdev)
>>  {
>> -	return sdev->sdev_state != SDEV_OFFLINE;
>> +	return (sdev->sdev_state != SDEV_OFFLINE &&
>> +		sdev->sdev_state != SDEV_CANCEL &&
>> +		sdev->sdev_state != SDEV_DEL);
> 
> SDEV_DEL is OK.  We can't do this for SDEV_CANCEL because that will
> block post removal commands (notably cache flush).
> 
You are correct as usual. Updated patch attached.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------030705000803080804040003
Content-Type: text/plain;
 name="scsi-check-for-deleted-device-in-scsi_device_online"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-check-for-deleted-device-in-scsi_device_online"

scsi_device_online() is not just a negation of SDEV_OFFLINE,
also devices in state SDEV_DEL are actually offline.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e96daf6..bb80937 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -401,7 +401,8 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
  */
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
-	return sdev->sdev_state != SDEV_OFFLINE;
+	return (sdev->sdev_state != SDEV_OFFLINE &&
+		sdev->sdev_state != SDEV_DEL);
 }
 static inline int scsi_device_blocked(struct scsi_device *sdev)
 {

--------------030705000803080804040003--
