From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 2/5] - fusion - target reset when drive is being removed
Date: Thu, 26 Jan 2006 10:14:32 -0500
Message-ID: <43D8E758.8040702@emulex.com>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1FEDAC@NAMAIL2.ad.lsil.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:2277 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932353AbWAZPOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 10:14:47 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1FEDAC@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@SteelEye.com, hch@infradead.org

Yep - makes sense.

So, where I was driving to, Target Reset is a f/w command, not the actual
Task Management Function "Target Reset". No need to follow up..

Thanks.

-- james

Moore, Eric wrote:
> On Thursday, January 26, 2006 7:40 AM, James Smart wrote:
>> Interesting that you took this path.  I'm working on something similar
>> for the FC transport. When we finally decide the device is gone, we
>> want to kill the outstanding i/o. First thought in my mind was to use
>> a TMF - but this implies that you can contact the device to 
>> do the TMF.
>> Are you sending this before the device has actually gone away 
>> ?  If it's
>> after, I assume this then is a firmware function that handles things
>> accordingly at the link layer (e.g. may not send the TMF, 
>> will internally
>> abort the outstanding io's, may note the TR request and do it when the
>> device is later detected.... and so on).
>>
> 
> The target reset is issued from the device driver slave_destroy entry
> point.
> 
> This occurs after the device has been removed.   Meaning the driver
> receives a firmware event saying a device was deleted, then the driver
> calls the sas_transport layer to report the deleted device.  Then
> the scsi mid-layer calls the slave_destroy entry point, then the
> target reset is called.
> 
> This sole purpose is merely telling the firmware to complete the
> outstanding 
> commands back to the driver, so the mid-layer is getting all completed
> io
> for the device, thus preventing any future driver eh_threads from being
> called.
> 
> This was implemented in the LSI internal drivers some time ago, at that
> time
> when the driver received the "device delete" event, the device could
> still be
> getting io from above, and/or still have io pending in its queue.  The
> target
> reset will flush the queue, and thus return all the io's with abort'd
> status back
> to the driver.  That is why I had the target reset from the
> slave_destroy. 
> 
> Eric
> 
