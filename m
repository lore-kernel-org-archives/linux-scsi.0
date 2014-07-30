From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V2 2/4] Introduce xen-scsifront module
Date: Wed, 30 Jul 2014 06:53:59 +0200
Message-ID: <53D87A67.8050005@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>	<1406288253-13293-3-git-send-email-jgross@suse.com>	<20140729135300.GA20415@infradead.org> <53D7B65C.8030701@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53D7B65C.8030701@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On 07/29/2014 04:57 PM, Juergen Gross wrote:
> On 07/29/2014 03:53 PM, Christoph Hellwig wrote:

>>> +        switch (op) {
>>> +        case VSCSIFRONT_OP_ADD_LUN:
>>> +            if (device_state == XenbusStateInitialised) {
>>> +                sdev = scsi_device_lookup(info->host, chn, tgt,
>>> +                              lun);
>>> +                if (sdev) {
>>> +                    dev_err(&dev->dev,
>>> +                        "Device already in use.\n");
>>> +                    scsi_device_put(sdev);
>>> +                    xenbus_printf(XBT_NIL, dev->nodename,
>>> +                              state_str, "%d",
>>> +                              XenbusStateClosed);
>>> +                } else {
>>> +                    scsi_add_device(info->host, chn, tgt,
>>> +                            lun);
>>> +                    xenbus_printf(XBT_NIL, dev->nodename,
>>> +                              state_str, "%d",
>>> +                              XenbusStateConnected);
>>> +                }
>>> +            }
>>> +            break;
>>
>> scsi_add_device handles an already existing device just fine, and unlike
>> this construct isn't racy.
>
> Okay. I'll change it.

Hmm, I looked into scsi_add_device(). It seems as if the caller can't
distinguish between a new created and an already existing device. Am I
missing something?

The race is not existing: scsi_add_device() (and scsi_remove_device()
as well) for this scsi_host is called in scsifront_do_lun_hotplug()
only, and this function is always called in the same thread (xenbus
watch). A comment seems to be a good idea.


Juergen
