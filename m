From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] SCSI, st: modify tape driver to allow writing immediate
 filemarks
Date: Thu, 09 Feb 2012 09:43:37 -0800
Message-ID: <4F3405C9.3020606@suse.com>
References: <4F31CAC0.3010905@suse.com> <alpine.LNX.2.00.1202081910400.6087@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1202081910400.6087@kai.makisara.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/08/2012 09:19 AM, Kai Makisara wrote:
> On Tue, 7 Feb 2012, Lee Duncan wrote:
> 
>> Add an st module option st_nowait_eof which defaults to 0. Setting this
>> option to 1 tells the st driver not to wait when writing a filemark, which
>> can result in much faster times on streaming tape drives.
>>
>> Legacy applications cannot take advantage of the newer MTWEOFI ioctl, so this
>> patch gives such applications the ability to write an immediate EOF using the
>> normal MTWEOF ioctl if they set st_nowait_eof=1.
>>
>> Reference: https://bugzilla.novell.com/show_bug.cgi?id=688996
>>
> Is there a real application? I can't open your reference. (Yes, I know 
> that this feature can speed up writing dramatically in some cases, but is 
> there a case with legacy applications?)

Yes, there are real applications. My apologies for supplying a Reference
to a non-public bug listing. This bug appeared because SAN backup
software was writing to an LT04 tape drive, but performance sucked.

I was able to reproduce the problem with a simple program that wrote a
megabyte then an EOF to my LT04, then a megabyte then another EOF. Any
tape backup or copy program that uses this basic pattern will exhibit
this problem.

> 
> Anyway, I don't think this should be implemented as a pure module option. 
> The standard semantics specify that MTWEOF is a synchronization point and 
> this module option breaks that for all users.

The Standard specifies that writing a filemark (i.e. an EOF) is a
synchronization point if and only if the data is being written in
immediate mode. In other words, you are not supposed to set both
immediate writes and immediate EOFs. This is why I didn't overload the
already-existing "immediate" flag in the driver.

I will add a check to the driver to disallow immediate EOFs if immediate
writes are requested.

> 
> The driver supports several tape device files with different properties 
> that can be set at run-time. Why not implement this as one of the mode 
> options? This would allow the "normal" users to use a device file with 
> synchronizing MTWEOF and the users needing unsynchronizing MTWEOF would 
> use another device file.
> 
> The st driver exports the options in sysfs. This is important so that the 
> users can check what the options for a device are. This new option should 
> also be exported.
> 
> Kai

Thanks, Kai. I agree with this. I will update my patch and resubmit.
-- 
Lee Duncan
