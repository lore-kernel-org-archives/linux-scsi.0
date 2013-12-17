From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/32] Refcounts and rbtrees to increase luns above 255
Date: Tue, 17 Dec 2013 11:53:07 +0100
Message-ID: <52B02D13.9000207@suse.de>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com> <1387231426.20247.260.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387231426.20247.260.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/16/2013 11:03 PM, Nicholas A. Bellinger wrote:
> On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
>> Hi Nicholas,
>>
>> This patchset uses krefs to refcount structures shared across thread=
s.
>> LIO is full of these because configfs-based configuration actions ca=
n
>> be removing an object, even while that object is being used by a SCS=
I
>> command.
>>
>> Using kref to free the struct on whichever thread drops the last
>> reference allows us to avoid busy-waiting in configfs removal functi=
ons.
>> Next, this set removes the statically-sized tpg lun and deve arrays =
in
>> favor of dynamically adding entries into rbtrees. This reduces memor=
y
>> consumption and allows more than 255 luns per tpg and initiator mapp=
ing.
>>
>> Except for some rbtree lookups, these changes are entirely in the
>> configuration paths of Lio. I have tested these as extensively as I =
can,
>> and it's ready for wider testing.
>>
>> Note: patch 22 converts a percpu refcount to a normal kref. I'd argu=
e
>> the benefit is really in the "refcount" part rather than the "percpu=
",
>> so a simpler kref does the job, but we might want to discuss this so=
me
>> more.
>>
>=20
> It would be helpful to breakup future patches into different series
> based on:
>=20
>   * Bugfixes
>   * New features
>   * Minor improvements
>=20
But the LUN addressing improvements is interesting.

What I found during development of the 64bit LUN patchset is
that the target core stuff has a very rudimentary LUN handling:
- 256 LUNs only
- LUNs are kept in a static array
- Identity mapping between LUN numbers and array indices.

What I _really_ would like to have is to do away with the
LUN array, and introduce a dynamic LUN mapping.
This will allow us to easily implement different LUN enumeration
methods (Think of hierarchical LUNs ...).

Also the assumption that a static array is always faster for
lookup than a linked list is wrong.
A static array is faster if the entire array fits into the processor
cache. If it doesn't we basically have an immediate
cache miss _for every array access_.
Then linked lists etc really are faster.

So do not take things at face value; only real measurements
count here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
