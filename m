From: Sergey Meirovich <rathamahata@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Tue, 7 Jan 2014 20:37:23 +0200
Message-ID: <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz> <20140107155830.GA28395@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48637 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaAGShq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2014 13:37:46 -0500
In-Reply-To: <20140107155830.GA28395@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>

Hi Christoph,

On 7 January 2014 17:58, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jan 06, 2014 at 09:10:32PM +0100, Jan Kara wrote:
>>   This is likely a problem of Linux direct IO implementation. The thing is
>> that in Linux when you are doing appending direct IO (i.e., direct IO which
>> changes file size), the IO is performed synchronously so that we have our
>> life simpler with inode size update etc. (and frankly our current locking
>> rules make inode size update on IO completion almost impossible). Since
>> appending direct IO isn't very common, we seem to get away with this
>> simplification just fine...
>
> Shouldn't be too much of a problem at least for XFS and maybe even ext4
> with the workqueue based I/O end handler.  For XFS we protect size
> updates by the ilock which we already taken in that handler, not sure
> what ext4 would do there.
>

Actually my initial report (14.67Mb/sec  3755.41 Requests/sec) was about ext4
However I have tried XFS as well. It was a bit slower than ext4 on all
occasions.
On the same machine results for XFS were:

    13.97Mb/sec  3576..27 Requests/sec

/dev/mapper/mpathc on /mnt/xfs type xfs (rw,noatime,nodiratime,nobarrier)
