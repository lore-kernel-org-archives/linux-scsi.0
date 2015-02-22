From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 5/8] target: Add sanity checks for DPO/FUA bit usage
Date: Sun, 22 Feb 2015 15:19:16 -0500
Message-ID: <54EA39C4.9040907@interlog.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com> <1423884463-16797-6-git-send-email-nab@daterainc.com> <20150222164114.GA1484@lst.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150222164114.GA1484@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 15-02-22 11:41 AM, Christoph Hellwig wrote:
> On Sat, Feb 14, 2015 at 03:27:40AM +0000, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>
>> This patch adds a sbc_check_dpofua() function that performs sanity
>> checks for DPO/FUA command bits.
>>
>> It introduces checks to fail when either bit is set, but the backend
>> device is not advertising support for them.
>>
>> It also moves the existing cmd->se_cmd_flags |= SCF_FUA assignement
>> into the new helper function.
>
> This causes I/O errors with ext4 on tcm_loop on what seems to be the first
> journal commit:
>
> [   41.818126] EXT4-fs (sdc): mounted filesystem with ordered data mode. Opts: (null)
> [   48.919107] Got CDB: 0x2a with FUA bit set, but device does not advertise support for FUA write
> [   48.920245] sd 3:0:0:0: [sdc] tag#113 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [   48.921219] sd 3:0:0:0: [sdc] tag#113 Sense Key : Illegal Request [current]
> [   48.921980] sd 3:0:0:0: [sdc] tag#113 Add. Sense: Invalid field in cdb

Setting (or clearing) the FUA bit on READ or WRITE commands
does not cause an error according to sbc4r05 irrespective of
the LU's support for volatile and non-volatile caches. I'm
pretty sure that hasn't changed recently (say 15 years).

There is the curious DPOFUA bit in the device specific parameter
field for block devices. It can be fetched with MODE SENSE and serves
to inform the app client (Linux) that the DPO and FUA bit are
not supported. Hence when those bits are used in commands associated
with reading and writing the medium, they should acted upon if
supported or else ignored silently.


Please consider the code in scsi_debug (i.e. mk_sense_invalid_fld())
to set the sense key specific sense data on Illegal Requests. This
is to set the Field pointer to indicate which byte (and optionally
bit) in the cdb (or parameter data) that the target objects to.

Doug Gilbert
