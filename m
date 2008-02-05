From: Matteo Tescione <matteo@rmnet.it>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux
 kernel
Date: Tue, 05 Feb 2008 18:09:15 +0100
Message-ID: <C3CE56CB.57D4%matteo@rmnet.it>
References: <20080205223740L.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758638AbYBERLj@vger.kernel.org>
In-Reply-To: <20080205223740L.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, mangoo@wpkg.org
Cc: vst@vlnb.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On 5-02-2008 14:38, "FUJITA Tomonori" <tomof@acm.org> wrote:

> On Tue, 05 Feb 2008 08:14:01 +0100
> Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> 
>> James Bottomley schrieb:
>> 
>>> These are both features being independently worked on, are they not?
>>> Even if they weren't, the combination of the size of SCST in kernel plus
>>> the problem of having to find a migration path for the current STGT
>>> users still looks to me to involve the greater amount of work.
>> 
>> I don't want to be mean, but does anyone actually use STGT in
>> production? Seriously?
>> 
>> In the latest development version of STGT, it's only possible to stop
>> the tgtd target daemon using KILL / 9 signal - which also means all
>> iSCSI initiator connections are corrupted when tgtd target daemon is
>> started again (kernel upgrade, target daemon upgrade, server reboot etc.).
> 
> I don't know what "iSCSI initiator connections are corrupted"
> mean. But if you reboot a server, how can an iSCSI target
> implementation keep iSCSI tcp connections?
> 
> 
>> Imagine you have to reboot all your NFS clients when you reboot your NFS
>> server. Not only that - your data is probably corrupted, or at least the
>> filesystem deserves checking...

Don't know if matters, but in my setup (iscsi on top of drbd+heartbeat)
rebooting the primary server doesn't affect my iscsi traffic, SCST correctly
manages stop/crash, by sending unit attention to clients on reconnect.
Drbd+heartbeat correctly manages those things too.
Still from an end-user POV, i was able to reboot/survive a crash only with
SCST, IETD still has reconnect problems and STGT are even worst.

Regards,
--matteo
