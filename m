From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: TMSCSIM [2.6]
Date: Wed, 26 Nov 2003 05:58:40 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC3C280.8090006@yk.rim.or.jp>
References: <Pine.LNX.4.44.0311242331460.2874-101000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl901.nas911.n-yokohama.nttpc.ne.jp ([210.139.42.133]:10440
	"EHLO standard.erephon") by vger.kernel.org with ESMTP
	id S263189AbTKYU65 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 15:58:57 -0500
Received: from (client is using the wrong hostname!) yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1AOkGm-00391fC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2003 05:58:48 +0900 (JST)
In-Reply-To: <Pine.LNX.4.44.0311242331460.2874-101000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> Didn't pass uncompressed through - bigger than 100K? Attaching compressed.
> 
> On Mon, 24 Nov 2003, Guennadi Liakhovetski wrote:
> 
> 
>>Ghm, here's the patch. But I decided not to compress it, just send it as
>>attachment, instead of inlining it - after all, this is how it should be
>>done, isn't it?:-)
>>
>>And - now it includes one more fix - replaced deprecated check_region()
>>with request_region() - noticed by Ishikawa, Chiaki.

Hello,

Thank you for the renewed patch.

I am using TEKRAM dc390. I use tmscsim driver as a module.
There is a PD/CD combo on the dc390 scsi bus. (PD is
a somewhat outdated optomagnetic drive. The drive has
two LUNs, one for CD, and one for PD. PD side is recognized as
rewritable removable media at least under 2.4.22.)

With the modified tmscsim driver under 2.6.0-test10,
(the bzipped patch submitted to linux-scsi worked without rejection)
I got a panic after module insertion during booting.
tmscsim is mentioned in /etc/modules and so inserted automatically
during booting.

(More background: related stuff I can think of.
       kernel 2.6.0-test10.
       tmscsim ... used as module
       sr ... module as sr_mod
       event mechanism enabled in the kernel.
       gcc 3.3 used...)

Here is the panic message left on the screen which I scribbed down
manually.

	... anything above is scrolled and disappeared but I saw the
         module insertion began. ...
esi: ef63a2f0 edi: 00000001 ebp: c03a5e4c esp: c03a5e3c
ds: 007b es: 007b ss: 0068

Process swapper (pid:0, threadinfo = c03a4000, task=c0338680)

Stack: 00000000 ef63a2f0 efc617c0 ef5e92c0 c0ea5e8c f09451d1 ef63a2f0 
ef63a2f0
        ef5e92c0 ef5e92c0 c03a5ea4 f09451d1 ef63a2f0 4f89f21d 00000021 
00000001
        cc000092 ef63a2f0 efc617c0 ef63a208 c03a5ec4 f0946e36 ef63a208 
ef5e92c0

Call trace:
   [<f09451d1>] dc390_StartSCCSI+0x41/0x330    [tmscsim]
   [<f09451d1>] dc390_StartSCCSI+0x41/0x330    [tmscsim]
   [<f0946e36>] dc390_SRBdone+0x306/0x5b0      [tmscsim]
   [<f09472f3>] dc390_RequestSense+0x53/0x90   [tmscsim]
   [<f0946714>] dc390_Disconnect+0x104/0x160    [tmscsim]
   [<f094574a>] do_DC390_Interrupt:0x28d/0x350 [tmscsim]
   [<c025dc88>] scsi_softirq+0xe8/0x240
   [<c010da4b>] handle_IRQ_event:0x3b/0x70
   [<c010e060>] do_IRQ+0x140/0x390
   [<c0105000>] _stext+0x0/0xf0
   [<c010c0ec>] common_interrupt:0x18/0x20
   [<c0105000>] _stext+0x0/0xf0
   [<c0108ea6>] default_idel+0x26/0x30
   [<c0108f24>] cpu_idle+0x34/0x40
   [<c03a6797>] start_kernel+0x1e7/0x270
   [<c03a6480>] unknown_bootoption+0x0/0x100

Code: 0f 0b 28 00 77 9d 94 f0 eb c5 0f 0b 25 00 77 9d 94 f0 eb e8

<0> Kernel panic: Fatal exception in interrupt
     In interrupt handler --- not syncing




OBSERVATION:

	alt sysreq magic key combination worked.
	I could run emergency sync and reboot.

	From the kernel panic message, and the call trace, it looks to
	me that the interrupt is recursively entered somehow.
	(Or unexpected interrupt came in.)


So what next?
I can enable debugging macro if necessary and re-try.

Or, I can disable tmscsim module insertion during booting,
and try "insmod tmscsim" after the kernel is up and running and
see if it makes difference.

(Under 2.6.0-test9, and manually fixed patched tmscsim files (due to
whitespace problems of the patch), I could insert the tmscsim module
but "insmod tmscsim" took unusually long time, but eventually
returned. However, /proc/scsi/ didn't show the 2nd LUN of the
PD/CD combo I have on dc390 bus. Maybe it was a problem of
insertion of sr_mod due to my misconfiguration of module set up
for 2.6.0-testXX which I believe is now corrected.
Since immediately
afterward when I tried automatic insertion of dc390 during booting,
I got a similar panic which I reported above, I didn't pursue
the insertion testing after the kernel is up and running.
I thought fixing the panic of auto insertion needs to be handled first.
But maybe I should re-try under test10 if this gives more insight.)




-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */

