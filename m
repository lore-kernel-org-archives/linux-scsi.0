From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v12 7/9] libata: scsi: no poll when ODD is powered off
Date: Mon, 14 Jan 2013 13:01:47 -0500
Message-ID: <50F4480B.7050001@pobox.com>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com> <1357809870-18816-8-git-send-email-aaron.lu@intel.com> <20130110195610.GL20454@htj.dyndns.org> <20130111021110.GB26270@aaronlu.sh.intel.com> <20130111021701.GA2513@mtj.dyndns.org> <20130111031626.GA26613@aaronlu.sh.intel.com> <20130111184457.GQ20454@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20130111184457.GQ20454@htj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/11/2013 01:44 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Jan 11, 2013 at 11:16:26AM +0800, Aaron Lu wrote:
>> OK, will make it atomic in next version, thanks for the advice.
>>
>> Perhaps I can add two scsi helper functions in scsi_lib.c like:
>>
>> void sdev_disable_disk_events(struct scsi_device *sdev)
>> {
>> 	atomic_inc(&sdev->disk_events_disable_depth);
>> }
>>
>> void sdev_enable_disk_events(struct scsi_device *sdev)
>> {
>> 	if (WARN_ON_ONCE(atomic_read(&sdev->disk_events_disable_depth) <= 0))
>> 		return;
>> 	atomic_dec(&sdev->disk_events_disable_depth);
>> }
>>
>> And call them in ATA layer. Do you like this?
>
> Sounds good to me.  James, how does the series look to you?

Indeed.  Want James' Acked-by for patch #1.

I think it's ready.  It can go into libata-dev.git #upstream, and be 
reverted prior to Linus push if James NAKs.

	Jeff



