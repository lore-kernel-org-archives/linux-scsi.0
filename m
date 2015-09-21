From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 04/30] cxlflash: Fix potential oops following LUN removal
Date: Mon, 21 Sep 2015 17:32:44 -0500
Message-ID: <2C23A6A9-A0A4-4E21-881B-6BC91C46F01B@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442438860-49316-1-git-send-email-mrochs@linux.vnet.ibm.com> <55FFF3EE.9050202@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:46038 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbbIUWcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2015 18:32:48 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 21 Sep 2015 16:32:47 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 2E4CB1FF0049
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:23:55 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8LMVZhH7864824
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 15:31:35 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8LMWhRe009449
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:32:45 -0600
In-Reply-To: <55FFF3EE.9050202@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 21, 2015, at 7:11 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 16.9.2015 23:27, Matthew R. Ochs wrote:
>> When a LUN is removed, the sdev that is associated with the LUN
>> remains intact until its reference count drops to 0. In order
>> to prevent an sdev from being removed while a context is still
>> associated with it, obtain an additional reference per-context
>> for each LUN attached to the context.
>> 
>> This resolves a potential Oops in the release handler when a
>> dealing with a LUN that has already been removed.
>> 
>> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>> Suggested-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>> drivers/scsi/cxlflash/superpipe.c | 36 ++++++++++++++++++++++++------------
>> 1 file changed, 24 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
>> index fa513ba..1fa4af6 100644
>> --- a/drivers/scsi/cxlflash/superpipe.c
>> +++ b/drivers/scsi/cxlflash/superpipe.c
>> @@ -880,6 +880,9 @@ static int _cxlflash_disk_detach(struct scsi_device *sdev,
>> 			sys_close(lfd);
>> 	}
>> 
>> +	/* Release the sdev reference that bound this LUN to the context */
>> +	scsi_device_put(sdev);
>> +
> 
> I'm not sure here with the use if scsi_device_get+put, also I don't quite well
> understand what you are going to fix here and how can it happen.
> The scsi_device_get takes an additional module reference, so if used from
> a module it shouldn't be held for a long time.

The issue here is that the user context needs to be bound to the device so that
in the event that device goes away, it doesn't completely go away until the user
context is done using it. Without it, it is possible to crash when the context is
being freed.

Essentially this is the same as incrementing the count when an open is performed
on the device. The device can be removed (and is hidden upon doing so) but is
not actually freed until the reference is resolved (close()).

> Is it possible for a user to rmmod the czlflash module
> after the disk attach function is called?

Not while a user is present.


