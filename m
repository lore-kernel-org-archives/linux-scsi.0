From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 5/8] target: Add sanity checks for DPO/FUA bit usage
Date: Sun, 22 Feb 2015 16:48:30 -0500
Message-ID: <54EA4EAE.6090906@interlog.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com>	 <1423884463-16797-6-git-send-email-nab@daterainc.com>	 <20150222164114.GA1484@lst.de> <54EA39C4.9040907@interlog.com> <1424637895.2146.128.camel@HansenPartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1424637895.2146.128.camel@HansenPartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 15-02-22 03:44 PM, James Bottomley wrote:
> On Sun, 2015-02-22 at 15:19 -0500, Douglas Gilbert wrote:
>> On 15-02-22 11:41 AM, Christoph Hellwig wrote:
>>> On Sat, Feb 14, 2015 at 03:27:40AM +0000, Nicholas A. Bellinger wrote:
>>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>>
>>>> This patch adds a sbc_check_dpofua() function that performs sanity
>>>> checks for DPO/FUA command bits.
>>>>
>>>> It introduces checks to fail when either bit is set, but the backend
>>>> device is not advertising support for them.
>>>>
>>>> It also moves the existing cmd->se_cmd_flags |= SCF_FUA assignement
>>>> into the new helper function.
>>>
>>> This causes I/O errors with ext4 on tcm_loop on what seems to be the first
>>> journal commit:
>>>
>>> [   41.818126] EXT4-fs (sdc): mounted filesystem with ordered data mode. Opts: (null)
>>> [   48.919107] Got CDB: 0x2a with FUA bit set, but device does not advertise support for FUA write
>
> Where is this coming from?  It's not a message I can find in the current
> kernel.
>
>>> [   48.920245] sd 3:0:0:0: [sdc] tag#113 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>> [   48.921219] sd 3:0:0:0: [sdc] tag#113 Sense Key : Illegal Request [current]
>>> [   48.921980] sd 3:0:0:0: [sdc] tag#113 Add. Sense: Invalid field in cdb
>>
>> Setting (or clearing) the FUA bit on READ or WRITE commands
>> does not cause an error according to sbc4r05 irrespective of
>> the LU's support for volatile and non-volatile caches. I'm
>> pretty sure that hasn't changed recently (say 15 years).
>
> Well, firstly, that doesn't change the fact that sending FUA commands to
> a non-FUA supporting device is a bug because the stable storage
> guarantee the filesystem is relying on is broken.

> However, your characterisation of the standards isn't quite correct:
> you've forgotten SAT.  SAT allows a non FUA supporting ATA device to
> return illegal request ... and I bet this is what's happening.

That is indeed surprising. And I can see words to
support that (i.e. failing the command with illegal
request) for the translation of various SCSI READ
commands in sat4r00a.

However sat4r00a does not say that for WRITE commands.
It looks like the SATL given SCSI WRITE(FUA) in the
absence of ATA FUA support should translate that to
ATA WRITE followed by ATA VERIFY.

Since this case involves SCSI WRITE (FUA) being rejected
with Illegal Request then as far as I can see that is
wrong. The target subsystem might follow the same
pattern suggested by SAT and add a SCSI VERIFY when the
preceding WRITE has FUA set and it is not supported.

Doug Gilbert
