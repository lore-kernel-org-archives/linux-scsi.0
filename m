From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Wed, 25 May 2016 18:04:39 +0300
Message-ID: <CAJ3xEMjE3pfz7+QKMUheH9P+xyvj81qbCtbod0mBi7pUspMRXg@mail.gmail.com>
References: <cover.1461088672.git.varun@chelsio.com>
	<62c9d9c1e609c39f714ef15c10ba62b1cbbddecd.1461088673.git.varun@chelsio.com>
	<CAJ3xEMiyQaWwsgVd_J9eVXqPwPk6=VYN_iMoEJQGz=1wHFrHqQ@mail.gmail.com>
	<CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>
	<1464072025.22249.87.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464072025.22249.87.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, kxie@chelsio.com, indranil@chelsio.com, Steve Wise <swise@opengridcomputing.com>, Varun Prakash <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 24, 2016 at 9:40 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Hi Or & Co,
> On Wed, 2016-05-18 at 14:45 +0300, Or Gerlitz wrote:
>> On Sat, Apr 30, 2016 at 6:54 PM, Or Gerlitz <gerlitz.or@gmail.com> wrote:
>> > On Tue, Apr 19, 2016 at 9:30 PM, Varun Prakash <varun@chelsio.com> wrote:
>> >> cxgbit.h - This file contains data structure
>> >> definitions for cxgbit.ko.
>> >>
>> >> cxgbit_lro.h - This file contains data structure
>> >> definitions for LRO support.
>> >>
>> >> cxgbit_main.c - This file contains code for
>> >> registering with iscsi target transport and
>> >> cxgb4 driver.
>> >>
>> >> cxgbit_cm.c - This file contains code for
>> >> connection management.
>> >>
>> >> cxgbit_target.c - This file contains code
>> >> for processing iSCSI PDU.
>> >>
>> >> cxgbit_ddp.c - This file contains code for
>> >> Direct Data Placement.
>> >
>> > Wait,
>> >
>> > You are adding many K's LOCs to handle things like CM (connection
>> > management), DDP and LRO. But your upstream solution must be using CM
>> > and DDP (and LRO as well) for the HW offloaded initiator side as well,
>> > not to mention the iWARP side of things.
>> >
>> > There must be some way to refactor things instead of repeating the
>> > same bits over and over, thoughts?

>> The author haven't responded... where that this stands from your point of view?

> For an initial merge, I don't have an objection to this series wrt
> drivers/target/iscsi/* improvements + prerequisites, and new standalone
> cxgbit iscsit_transport driver.
>
> That said, there are areas between cxgbi + cxgbit code that can be made
> common as you've pointed out.  The Cheliso folks have mentioned off-list
> that cxgbi as-is in mainline does not support LRO, and that the majority
> of DDP logic is shared between initiator + target.
>
> Are there specific pieces of logic in DDP or iWARP for cxgb* that you'd
> like to see Varun + Co pursue as common code in v4.8+..?

Hi Nic,

As I wrote above, I have good reasons to believe that there are few K
LOCs of duplication
between this series to the chelsio hw iscsi initiator or the chelsio
iwarp driver or both (triple).

Ys, I'd like to see a public response from Varun and Co on this valid
reviewer comment
before you proceed with this series, makes sense? There's no point to
duplicate the same
code in the kernel again and again. **Even** if there's one
duplication now, we don't want
another one.

Or.
