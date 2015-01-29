From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Thu, 29 Jan 2015 13:16:37 +0100
Message-ID: <54CA24A5.1060806@sandisk.com>
References: <1421600146.2080.8.camel@HansenPartnership.com>
	 <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au>
	 <1421683701.2080.25.camel@HansenPartnership.com>
	 <871tmqcmau.fsf@rustcorp.com.au>
	 <1421774615.2080.88.camel@HansenPartnership.com>
	 <20150122165018.GA27377@infradead.org>
	 <1421946175.2093.1.camel@HansenPartnership.com>
	 <87iofyurzc.fsf@rustcorp.com.au> <20150123131758.GC8045@infradead.org>
	 <1422038567.2126.14.camel@HansenPartnership.com>
	 <54C8AAA9.7060300@sandisk.com>
 <1422481550.2086.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422481550.2086.16.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Rusty Russell <rusty@rustcorp.com.au>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/28/15 22:45, James Bottomley wrote:
> On Wed, 2015-01-28 at 10:23 +0100, Bart Van Assche wrote:
>> Is this the latest version of this patch that is available ? I have
>> tried to test the above patch. However, I couldn't test the impact of
>> this patch on the SRP initiator driver since my test system didn't boot
>> anymore with the above patch applied. That test system boots from an ATA
>> disk managed by the SCSI subsystem:
>> $ lsscsi | head -n1
>> [0:0:0:0]    disk    ATA      KINGSTON SH103S3 BBF0  /dev/sda
> 
> Not yet, since I knew it would need a bit of testing to identify all the
> potential in_exit acquisitions.  However, you could help me by
> diagnosing the current failure.

Hello James,

I have done the following:
- Read over your patch but didn't spot anything obvious.
- Added printk() statements in the modified functions in an attempt to
  determine where in the boot process the hang occurs. Apparently none
  of the functions touched by this patch got called before the hang
  occurred.
- Uploaded a screenshot of the boot messages
(https://drive.google.com/file/d/0B1YQOreL3_FxN1pPMnZrSDdLYTQ/view?usp=sharing).
The most remarkable message is "SATA link down". This message does not
appear when booting e.g. kernel version v3.16.
- Left the system alone for a few minutes after the boot process
  stopped making progress. The message "boot drive not found" appeared.

So this is probably an issue in another component than the SCSI
subsystem. What's not clear to me is why every time I tried to boot
without this patch that booting succeeded and every time I tried to boot
with this patch applied that booting did not succeed ... I have not yet
had the time to run a bisect.

Note: the tests I ran today were performed with kernel v3.19-rc6 with
patch https://lkml.org/lkml/2015/1/28/334 applied. However, that last
patch shouldn't have any impact on the boot process since
CONFIG_SCSI_MQ_DEFAULT was not set.

Bart.
