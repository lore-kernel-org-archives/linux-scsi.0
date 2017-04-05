From: David Buckley <dbuckley@oreilly.com>
Subject: Re: problem with discard granularity in sd
Date: Wed, 5 Apr 2017 09:14:45 -0700
Message-ID: <CA+Xd3XGwXZRat_zF=3vraT81jm7WgU1RSjdNeNDBfioYD9-B9Q@mail.gmail.com>
References: <CA+Xd3XHp381w87Fr5_HGU5gBpWMSRSwD+pRacGkHu7Rp7CYUfg@mail.gmail.com>
 <yq1d1crvhjv.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34409 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752675AbdDEQP2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 12:15:28 -0400
Received: by mail-lf0-f54.google.com with SMTP id z15so12543820lfd.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 09:15:27 -0700 (PDT)
In-Reply-To: <yq1d1crvhjv.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Hi Martin,

I really appreciate the response. Here is the VPD page data you asked for:

Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBWS): 1
  Write same (10) with unmap bit supported (LBWS10): 1
  Logical block provisioning read zeros (LBPRZ): 1
  Anchored LBAs supported (ANC_SUP): 0
  Threshold exponent: 0
  Descriptor present (DP): 0
  Provisioning type: 2

Block limits VPD page (SBC):
  Write same no zero (WSNZ): 1
  Maximum compare and write length: 1 blocks
  Optimal transfer length granularity: 8 blocks
  Maximum transfer length: 8388607 blocks
  Optimal transfer length: 128 blocks
  Maximum prefetch length: 0 blocks
  Maximum unmap LBA count: 8192
  Maximum unmap block descriptor count: 64
  Optimal unmap granularity: 8
  Unmap granularity alignment valid: 1
  Unmap granularity alignment: 0
  Maximum write same length: 0x4000 blocks


As I mentioned previously, I'm fairly certain that the issue I'm
seeing is due to the fact that while NetApp LUNs are presented as 512B
logical/4K physical disks for compatibility, they actually don't
support requests smaller than 4K (which makes sense as NetApp LUNs are
actually just files allocated on the 4K-block WAFL filesystem).

If the optimal granularity values from VPD are respected (as is the
case with 3.10 kernels), the result is:

minimum_io_size = 512 *8 = 4096  (logical_block_size * VPD optimal
transfer length granularity)
discard_granularity = 512 * 8 = 4096  (logical_block_size * VPD
optimal unmap granularity)


With recent kernels the value of minimum_io_size is unchanged, but
discard_granularity is explicitly set to logical_block_size which
results in unmap requests either being dropped or ignored.

I understand that the VPD values from LUNs may be atypical compared to
physical disks, and I expect there are some major differences in how
unmap (and zeroing) is handled between physical disks and LUNs.  But
it is unfortunate that a solution for misaligned I/O would break
fully-aligned requests which worked flawlessly in previous kernels.

Let me know if there's any additional information I can provide. This
has resulted in a 2-3x increase in raw disk requirements for some
workloads (unfortunately on SSD too), and I'd love to find a solution
that doesn't require rolling back to a 3.10 kernel.

Thanks again!
-David



On Tue, Apr 4, 2017 at 5:12 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> David Buckley <dbuckley@oreilly.com> writes:
>
> David,
>
>> They result in discard granularity being forced to logical block size
>> if the disk reports LBPRZ is enabled (which the netapp luns do).
>
> Block zeroing and unmapping are currently sharing some plumbing and that
> has lead to some compromises. In this case a bias towards ensuring data
> integrity for zeroing at the expense of not aligning unmap requests.
>
> Christoph has worked on separating those two functions. His code is
> currently under review.
>
>> I'm not sure of the implications of either the netapp changes, though
>> reporting 4k logical blocks seems potential as this is supported in
>> newer OS at least.
>
> Yes, but it may break legacy applications that assume a 512-byte logical
> block size.
>
>> The sd change potentially would at least partially undo the patches
>> referenced above.  But it would seem that (assuming an aligned
>> filesystem with 4k blocks and minimum_io_size=4096) there is no
>> possibility of a partial block discard or advantage to sending the
>> discard requests in 512 blocks?
>
> The unmap granularity inside a device is often much, much bigger than
> 4K. So aligning to that probably won't make a difference. And it's
> imperative to filesystems that zeroing works at logical block size
> granularity.
>
> The expected behavior for a device is that it unmaps whichever full
> unmap granularity chunks are described by a received request. And then
> explicitly zeroes any partial chunks at the head and tail. So I am
> surprised you see no reclamation whatsoever.
>
> With the impending zero/unmap separation things might fare better. But
> I'd still like to understand the behavior you observe. Please provide
> the output of:
>
> sg_vpd -p lbpv /dev/sdN
> sg_vpd -p bl /dev/sdN
>
> for one of the LUNs and I'll take a look.
>
> Thanks!
>
> --
> Martin K. Petersen      Oracle Linux Engineering
