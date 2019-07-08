From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Mon, 8 Jul 2019 09:02:23 -0400
Message-ID: <5155c7bd-f339-33bb-1a84-18ea75963db2@interlog.com>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
 <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
 <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
 <da579578-349e-1320-0867-14fde659733e@acm.org>
 <AT5PR8401MB11695CC7286B2D2F98FB9EADABEA0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <1ad3e7ba-008d-31ad-89a0-b118b36e14e2@suse.de>
 <e2469890-e0ae-fb79-4aa9-125cdaeedb2b@interlog.com>
 <284c3ecc-b3a8-eeec-92d5-5eda1f20f691@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <284c3ecc-b3a8-eeec-92d5-5eda1f20f691@suse.de>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Elliott, Robert (Servers)" <elliott@hpe.com>, Bart Van Assche <bvanassche@acm.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 2019-07-08 2:01 a.m., Hannes Reinecke wrote:
> On 7/5/19 7:53 PM, Douglas Gilbert wrote:
>> On 2019-07-05 3:22 a.m., Hannes Reinecke wrote:
> [ .. ]
>>> As mentioned, rescan-scsi-bus.sh is keeping references to /proc/scsi as
>>> a fall back only, as it's meant to work kernel independent. Per default
>>> it'll be using /sys, and will happily work without /proc/scsi.
>>>
>>> So it's really only /proc/scsi/sg which carries some meaningful
>>> information; maybe we should move/copy it to somewhere else.
>>>
>>> I personally like getting rid of /proc/scsi.
>>
>> /proc/scsi/device_info doesn't seem to be in sysfs.
>>
>> Could the contents of /proc/scsi/sg/* be placed in
>> /sys/class/scsi_generic/* ? Currently that directory only has symlinks
>> to the sg devices.
>>
> The sg parameters are already available in /sys/module/sg/parameters;
> so from that perspective I feel we're good.

# ls /sys/module/sg/parameters/
allow_dio  def_reserved_size  scatter_elem_sz

# ls /proc/scsi/sg/
allow_dio  debug  def_reserved_size  device_hdr  devices  device_strs
red_debug  version

So that doesn't work, what are in 'parameters' are passed in at
module/driver initialization. Back to my original question: Could the
contents of /proc/scsi/sg/* be placed in /sys/class/scsi_generic/* ?

> Problem is /proc/scsi/device_info, for which we currently don't have any
> other location to store it at.
> Hmm.

Doug Gilbert
