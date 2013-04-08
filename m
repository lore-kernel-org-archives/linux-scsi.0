From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/3] PCI: Handle device quirks when accessing sysfs
 resource<N> entries
Date: Mon, 8 Apr 2013 11:29:17 -0600
Message-ID: <CAErSpo5rgDUUPB6DX1t_3k_d+YD7eFkGPJmgX0bxs7iFsjowBw@mail.gmail.com>
References: <20130321043449.7229.81056.stgit@amt.stowe> <20130321043502.7229.43877.stgit@amt.stowe>
 <514BAB13.3000101@gmail.com> <CAErSpo4FajG4hz8ELinnFLjk_3j=gQpC9zi4jR6pi=qoOda5cg@mail.gmail.com>
 <1365238164.2787.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1365238164.2787.6.camel@dabdike>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Myron Stowe <myron.stowe@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Xiangliang Yu <yuxiangl@marvell.com>, xiangliang yu <yxlraid@gmail.com>, Greg Kroah-Hartman <greg@kroah.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Apr 6, 2013 at 2:49 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2013-04-04 at 12:06 -0600, Bjorn Helgaas wrote:
>> On Thu, Mar 21, 2013 at 6:51 PM, Robert Hancock <hancockrwd@gmail.com> wrote:

>> > -Reconsider whether supporting read/write on the resource files for IO port
>> > regions like these makes any sense. Obviously mmap isn't very practical for
>> > IO port access on x86 but you could even do something like an ioctl for this
>> > purpose. Not very many pieces of software would need to access these files
>> > so it's likely OK if the API is a bit ugly. That would prevent something
>> > like grepping through sysfs from generating port accesses to random devices.
>>
>> This is the approach I'd like to push on for a kernel fix.
>
> Me too.  I think the quirks approach is unsupportable.  Worst case I
> think we should have an ability for the *driver* to mark the region as
> having strange access rules.
>
>>   I'm not a
>> VM person, but if it were possible to support .mmap() in such a way
>> that a handler would be called for every access to the region, we
>> could easily support I/O port access that way.
>
> We could ... the OS could trigger a page fault on every access using the
> COW mechanism ... however, that mechanism wasn't intended for write
> combining, so although it's theoretically possible to add it, I'd be a
> bit wary.

The current problem case is only I/O port accesses, so we only have to
support 1/2/4-byte accesses, and I don't think write combining is an
issue.  But it still sounds like COW might be trying to force a square
peg into a round hole.  Maybe there are other approaches.  I just
thought of .mmap() because that's already used for MEM space accesses.

Bjorn
