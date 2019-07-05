From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Fri, 5 Jul 2019 09:22:43 +0200
Message-ID: <1ad3e7ba-008d-31ad-89a0-b118b36e14e2@suse.de>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
 <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
 <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
 <da579578-349e-1320-0867-14fde659733e@acm.org>
 <AT5PR8401MB11695CC7286B2D2F98FB9EADABEA0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AT5PR8401MB11695CC7286B2D2F98FB9EADABEA0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, Bart Van Assche <bvanassche@acm.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, Marc Gonzalez <marc.w.gonzalez@free.fr>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 6/18/19 7:43 PM, Elliott, Robert (Servers) wrote:
> 
> 
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Bart
>> Van Assche
>> Sent: Monday, June 17, 2019 10:28 PM
>> To: dgilbert@interlog.com; Marc Gonzalez <marc.w.gonzalez@free.fr>; James Bottomley
>> <jejb@linux.ibm.com>; Martin Petersen <martin.petersen@oracle.com>
>> Cc: SCSI <linux-scsi@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; Christoph Hellwig
>> <hch@lst.de>
>> Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
>>
>> On 6/17/19 5:35 PM, Douglas Gilbert wrote:
>>> For sg3_utils:
>>>
>>> $ find . -name '*.c' -exec grep "/proc/scsi" {} \; -print
>>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>>> ./src/sg_read.c
>>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>>> ./src/sgp_dd.c
>>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>>> ./src/sgm_dd.c
>>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>>> ./src/sg_dd.c
>>>                  "'echo 1 > /proc/scsi/sg/allow_dio'\n", q_len,
>>> dirio_count);
>>> ./testing/sg_tst_bidi.c
>>> static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
>>> ./examples/sgq_dd.c
>>>
>>> That is 6 (not 38) by my count.
>>
>> Hi Doug,
>>
>> This is the command I ran:
>>
>> $ git grep /proc/scsi | wc -l
>> 38
>>
>> I think your query excludes scripts/rescan-scsi-bus.sh.
>>
>> Bart.
> 
> Here's the full list to ensure the discussion doesn't overlook anything:
> 
> sg3_utils-1.44$ grep -R /proc/scsi .
> ./src/sg_read.c:static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./src/sgp_dd.c:static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./src/sgm_dd.c:static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./src/sg_dd.c:static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./scripts/rescan-scsi-bus.sh:# Return hosts. /proc/scsi/HOSTADAPTER/? must exist
> ./scripts/rescan-scsi-bus.sh:  for driverdir in /proc/scsi/*; do
> ./scripts/rescan-scsi-bus.sh:    driver=${driverdir#/proc/scsi/}
> ./scripts/rescan-scsi-bus.sh:      name=${hostdir#/proc/scsi/*/}
> ./scripts/rescan-scsi-bus.sh:# Get /proc/scsi/scsi info for device $host:$channel:$id:$lun
> ./scripts/rescan-scsi-bus.sh:    SCSISTR=$(grep -A "$LN" -e "$grepstr" /proc/scsi/scsi)
> ./scripts/rescan-scsi-bus.sh:    DRV=`grep 'Attached drivers:' /proc/scsi/scsi 2>/dev/null`
> ./scripts/rescan-scsi-bus.sh:      echo "scsi report-devs 1" >/proc/scsi/scsi
> ./scripts/rescan-scsi-bus.sh:      DRV=`grep 'Attached drivers:' /proc/scsi/scsi 2>/dev/null`
> ./scripts/rescan-scsi-bus.sh:      echo "scsi report-devs 0" >/proc/scsi/scsi
> ./scripts/rescan-scsi-bus.sh:# Outputs description from /proc/scsi/scsi (unless arg passed)
> ./scripts/rescan-scsi-bus.sh:        echo "scsi remove-single-device $devnr" > /proc/scsi/scsi
> ./scripts/rescan-scsi-bus.sh:          echo "scsi add-single-device $devnr" > /proc/scsi/scsi
> ./scripts/rescan-scsi-bus.sh:      echo "scsi add-single-device $devnr" > /proc/scsi/scsi
> ./scripts/rescan-scsi-bus.sh:      echo "scsi add-single-device $devnr" > /proc/scsi/scsi
> ./scripts/rescan-scsi-bus.sh:      echo "scsi add-single-device $host $channel $id $SCAN_WILD_CARD" > /proc/scsi/scsi
> ./scripts/rescan-scsi-bus.sh:if test ! -d /sys/class/scsi_host/ -a ! -d /proc/scsi/; then
> ./ChangeLog:    /proc/scsi/sg/allow_dio is '0'
> ./ChangeLog:  - change sg_debug to call system("cat /proc/scsi/sg/debug");
> ./suse/sg3_utils.changes:  * Support systems without /proc/scsi
> ./examples/sgq_dd.c:static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
> ./doc/sg_read.8:If direct IO is selected and /proc/scsi/sg/allow_dio
> ./doc/sg_read.8:"echo 1 > /proc/scsi/sg/allow_dio". An alternate way to avoid the
> ./doc/sg_map.8:observing the output of the command: "cat /proc/scsi/scsi".
> ./doc/sgp_dd.8:at completion. If direct IO is selected and /proc/scsi/sg/allow_dio
> ./doc/sgp_dd.8:this at completion. If direct IO is selected and /proc/scsi/sg/allow_dio
> ./doc/sgp_dd.8:mapping to SCSI block devices should be checked with 'cat /proc/scsi/scsi'
> ./doc/sg_dd.8:notes this at completion. If direct IO is selected and /proc/scsi/sg/allow_dio
> ./doc/sg_dd.8:this at completion. If direct IO is selected and /proc/scsi/sg/allow_dio
> ./doc/sg_dd.8:with 'echo 1 > /proc/scsi/sg/allow_dio'.
> ./doc/sg_dd.8:mapping to SCSI block devices should be checked with 'cat /proc/scsi/scsi',
> 
> 
As mentioned, rescan-scsi-bus.sh is keeping references to /proc/scsi as
a fall back only, as it's meant to work kernel independent. Per default
it'll be using /sys, and will happily work without /proc/scsi.

So it's really only /proc/scsi/sg which carries some meaningful
information; maybe we should move/copy it to somewhere else.

I personally like getting rid of /proc/scsi.

Cheers,

-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
