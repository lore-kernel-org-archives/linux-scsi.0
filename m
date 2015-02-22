From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/8] target: Add sanity checks for DPO/FUA bit usage
Date: Sun, 22 Feb 2015 17:41:14 +0100
Message-ID: <20150222164114.GA1484@lst.de>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com> <1423884463-16797-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423884463-16797-6-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 14, 2015 at 03:27:40AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a sbc_check_dpofua() function that performs sanity
> checks for DPO/FUA command bits.
> 
> It introduces checks to fail when either bit is set, but the backend
> device is not advertising support for them.
> 
> It also moves the existing cmd->se_cmd_flags |= SCF_FUA assignement
> into the new helper function.

This causes I/O errors with ext4 on tcm_loop on what seems to be the first
journal commit:

[   41.818126] EXT4-fs (sdc): mounted filesystem with ordered data mode. Opts: (null)
[   48.919107] Got CDB: 0x2a with FUA bit set, but device does not advertise support for FUA write
[   48.920245] sd 3:0:0:0: [sdc] tag#113 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   48.921219] sd 3:0:0:0: [sdc] tag#113 Sense Key : Illegal Request [current] 
[   48.921980] sd 3:0:0:0: [sdc] tag#113 Add. Sense: Invalid field in cdb
[   48.922696] sd 3:0:0:0: [sdc] tag#113 CDB: Write(10) 2a 08 00 c4 22 c8 00 00 08 00
[   48.923619] blk_update_request: critical target error, dev sdc, sector 12853960
[   48.924501] blk_update_request: critical target error, dev sdc, sector 12853960
[   48.925598] Aborting journal on device sdc-8.
