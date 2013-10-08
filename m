From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug] 12.864681  BUG: lock held when returning to user space!
Date: Tue, 08 Oct 2013 09:45:35 -0400
Message-ID: <52540C7F.8050207@interlog.com>
References: <8761tilrl0.fsf@redhat.com> <874n8s2tjz.fsf@redhat.com> <5253A9E7.5030707@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5253A9E7.5030707@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>, Madper Xie <cxie@redhat.com>
Cc: linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 13-10-08 02:44 AM, vaughan wrote:
> Hi Madper,
>
> CC to Douglas to get comments.
> I use the rw_semaphore o_sem to protect excl open, introduced in commit
> 15b06f9a02406e5460001db6d5af5c738cd3d4e7 since v3.12-rc1.
> Is it forbidden to do like that in kernel?...

It appears you can not (allow sg_open() to hold a semaphore
then return to the user space). So you will need to do some
rework on that patch or revert it.

Doug Gilbert

Reference: scsi-linux + kernel lists, title:
   [PATCH v6 0/4][SCSI] sg: fix race condition in sg_open
   20130828

> On 10/08/2013 01:57 PM, Madper Xie wrote:
>> Howdy Vaughan Cao,
>>     I can't meet this issue on both 3.11 and 3.11.4. There are only four
>>     patches between 3.11 and 3.12-rc2 and you are the author. Will you
>>     please check them if you have time.
>>
>> cxie@redhat.com writes:
>>
>>> Hi all,
>>>     With kernel3.12-rc2 the dmesg shows following logs:
>>> [   12.864680] ================================================
>>> [   12.864681] [ BUG: lock held when returning to user space! ]
>>> [   12.864682] 3.12.0-rc2 #1 Not tainted
>>> [   12.864683] ------------------------------------------------
>>> [   12.864684] iprinit/719 is leaving the kernel with locks still held!
>>> [   12.864685] 1 lock held by iprinit/719:
>>> [   12.864686]  #0:  (&sdp->o_sem){.+.+..}, at: [<ffffffffa050de05>] sg_open+0x4b5/0x644 [sg]
>>> [   12.934954] ath9k 0000:01:00.0: enabling device (0000 -> 0002)
>>> [   12.940346] ath: phy0: timeout (1000 us) on reg 0x15f18: 0x00000000 & 0x00000007 != 0x00000004
>>> [   12.943125] ath: EEPROM regdomain: 0x60
>>> [   12.943127] ath: EEPROM indicates we should expect a direct regpair map
>>> [   12.943129] ath: Country alpha2 being used: 00
>>> [   12.943130] ath: Regpair used: 0x60
>>> [   12.960202] r8169 0000:02:00.0 p3p1: link down
>>> [   12.960236] r8169 0000:02:00.0 p3p1: link down
>>> [   12.960256] IPv6: ADDRCONF(NETDEV_UP): p3p1: link is not ready
>>> [   13.003523] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
>>> [   13.003886] ieee80211 phy0: Atheros AR9485 Rev:1 mem=0xffffc9000bc80000, irq=16
>>> [   13.012120] ip6_tables: (C) 2000-2006 Netfilter Core Team
>>> [   13.023667] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>> [   13.055802] Ebtables v2.0 registered
>>> [   13.192291] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>>> [   15.906392] r8169 0000:02:00.0 p3p1: link up
>>> [   15.906416] IPv6: ADDRCONF(NETDEV_CHANGE): p3p1: link becomes ready
>>> [   17.121989] systemd-udevd (334) used greatest stack depth: 3352 bytes left
>>>
>>> I'm working on finding which version bring this bug in.
>>
>
>
