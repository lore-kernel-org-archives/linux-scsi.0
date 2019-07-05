From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Fri, 5 Jul 2019 09:18:04 +0200
Message-ID: <719dd2ea-b5e5-c694-36ef-9513ed0c2d06@suse.de>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
 <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
 <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
 <da579578-349e-1320-0867-14fde659733e@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <da579578-349e-1320-0867-14fde659733e@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, dgilbert@interlog.com, Marc Gonzalez <marc.w.gonzalez@free.fr>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 6/18/19 5:28 AM, Bart Van Assche wrote:
> On 6/17/19 5:35 PM, Douglas Gilbert wrote:
>> For sg3_utils:
>>
>> $ find . -name '*.c' -exec grep "/proc/scsi" {} \; -print
>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>> ./src/sg_read.c
>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>> ./src/sgp_dd.c
>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>> ./src/sgm_dd.c
>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>> ./src/sg_dd.c
>>                  "'echo 1 > /proc/scsi/sg/allow_dio'\n", q_len,
>> dirio_count);
>> ./testing/sg_tst_bidi.c
>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>> ./examples/sgq_dd.c
>>  
>> That is 6 (not 38) by my count.
> 
> Hi Doug,
> 
> This is the command I ran:
> 
> $ git grep /proc/scsi | wc -l
> 38
> 
> I think your query excludes scripts/rescan-scsi-bus.sh.
> 
You can ignore rescan-scsi-bus.sh.
It's keeping /proc access as a fallback option only (as it's meant to be
kernel-independent); it will be using /sys per default and will happily
work without /proc/scsi.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
