From: Hannes Reinecke <hare@suse.com>
Subject: Re: scsi: myrs: warning fix, was: [GIT PULL] first round of SCSI
 updates for the 4.19+ merge window
Date: Fri, 26 Oct 2018 16:28:14 +0200
Message-ID: <512b7867-b809-9c10-88d1-7177bb522bc3@suse.com>
References: <1540378751.3008.59.camel@HansenPartnership.com>
 <CAK8P3a2R+5kLx=Fo2GTRagAk+4dPP-8GDfH9X7gCtQ7R8=bK_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2R+5kLx=Fo2GTRagAk+4dPP-8GDfH9X7gCtQ7R8=bK_g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, James.Bottomley@hansenpartnership.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/26/18 10:16 AM, Arnd Bergmann wrote:
> On Wed, Oct 24, 2018 at 1:00 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>>
>> James Bottomley (1):
>>        scsi: myrs: fix build failure on 32 bit
> 
> Hi James and Hannes,
> 
> Since James mentioned 32-bit compiles during the kernel summit,
> I'd like to confirm that I hit this on my randconfig builder now,
> with some latency since the last linux-next tree I tested before
> flying to Edinburgh did not have the bug, and the latest
> linux-next tree that is available now (dated last Friday) does, and
> I see your tree is fixed. During normal times, I should catch these
> within a short time of the patch getting into scsi-next.
> 
> However, while looking at this bug, I found two more issues related
> to the specific computation:
> 
> percent_complete = ldev_info->rbld_lba * 100 /  ldev_info->cfg_devsize;
> 
> I see that both rbld_lba and cfg_devsize are reported by the
> device, but only the former is 64 bit but the latter is 32 bit and
> also intended to be the larger of the two. I suspect this is a
> bug, and the same is also present in the old DAC960.c.
> cfg_devsize is followed by four reserved bytes in the header,
> so I suppose it was meant to be 64-bit?
> If you divide two 64-bit numbers, you also have to use div_u64_64()
> instead of do_div().
> 
> On top of that, I see we get those values from the device but
> never do any endianess conversion on them. It seems likely
> that they are all little-endian and require a le32_to_cpu()
> conversion to also work on big-endian kernel builds. Alternatively
> we could make the Kconfig symbol as
> 'depends on !CPU_BIG_ENDIAN || COMPILE_TEST'.
> 
It _really_ is questionable if these device ever work on big-endian 
machines, as they rely on the BIOS to start up the RAID engine; I've had 
a hard enough time getting them to work on normal machines :-)

Plus the firmware refused to handle any drive larger than 4GB (!), so 
it's really a purely theoretical issue whether 'cfgsize' was meant to be 
64 bit ...

Cheers,

Hannes


-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
