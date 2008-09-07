From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing 3-byte
 arrays as integers
Date: Sun, 07 Sep 2008 20:21:56 +0300
Message-ID: <48C40DB4.5050007@panasas.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>	 <48C3A0A9.3000206@panasas.com> <41b516cb0809070856v2000b93bm5305236e4a98b81a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:23486 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753891AbYIGRWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2008 13:22:18 -0400
In-Reply-To: <41b516cb0809070856v2000b93bm5305236e4a98b81a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <chris.leech@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>

Chris Leech wrote:
> On Sun, Sep 7, 2008 at 2:36 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> Chris Leech wrote:
>>> Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
>>> frame headers.  This patch defines __be24 and __le24 typedefs for a
>>> structure wrapped around a 3-byte array, and macros to convert back and
>>> forth to a 32-bit integer.
>>>
>>> The undefs in iscsi_proto.h are because of the different calling
>>> convention for the existing hton24 macro in the iSCSI code.  iSCSI will
>>> be converted in a subsequent patch.
>>>
>>> Signed-off-by: Chris Leech <christopher.leech@intel.com>
>> I like what this patch wants to accomplish, but I disagree with the
>> implementation.
>>
>> First why is the double definition, one in include/linux/byteorder.h
>> and one in include/linux/byteorder/generic.h ?
> 
> Because there are currently two byteorder/swab implementations in the
> kernel.  As you said Harvey Harrison has done a lot of work in this
> area, but right now only the arm and avr32 architectures make use of
> the new linux/byteorder.h.  I could put the 24-bit support in it's own
> header instead.
> 
>> Second and most important, in both these files all routines are inline's
>> not MACROs, and rightly so. There is no place for a macro and the MACRO
>> works bad for these.
> 
> I understand the benefits of inline functions, but I disagree that a
> macro is a bad choice in this case.  An inline implementation of
> cpu_to_be24/hton24 would require a different interface than the rest
> of the byteorder functions, looking more like the existing iSCSI
> hton24 macro by taking a pointer to a memory location to store the
> result in.
> 
> By using a macro that expands to a compound literal, I was able to
> maintain the same calling convention of X = cpu_to_be24(Y);
> Attempting to do so with an inline results in a function definition
> that returns a structure by value, and even when inlined generates
> much worse assembly (yes, I tried it).
> 
>> One - the definition of a local variable in a {} scope in the middle of anywhere.
> 
> That was done in order to only evaluate the macro operand only once,
> making it safe to call with an expression that may have side effects.
> Macros that create scoped variables are all over the place, like min,
> max and container_of.  I consider it necessary in creating a good
> macro implementation for this functionality, and my motivation for
> using macros was given above.
> 
>> Second - type safety.
> 
> Actually, the assignment to a locally scoped variable gives just as
> much type checking as an inline would :-)
> 
> Chris
> 
>> I CC: Harvey Harrison which did lots of work in these area's.
>>
>> For me this patch is totally unacceptable.
>>
>> Thanks for working on this
>> Boaz

I wanted to see what you're saying and tried this test code below:

<test.c>
#include "stdio.h"

typedef unsigned char __u8;
typedef unsigned int __u32;

typedef struct { __u8 b[3]; } __be24, __le24;

#define __be24_to_cpu(x) \
({ \
	__be24 _x = (x); \
	(__u32) ((_x.b[0] << 16) | (_x.b[1] << 8) | (_x.b[2])); \
})

static inline __u32 be24_to_cpu(__be24 _x)
{
	return (__u32) ((_x.b[0] << 16) | (_x.b[1] << 8) | (_x.b[2]));
}

#define __cpu_to_be24(x) \
({ \
	__u32 _x = (x); \
	(__be24) { .b = { (_x >> 16) & 0xff, (_x >> 8) & 0xff, _x & 0xff } }; \
})

static inline __be24 cpu_to_be24(__u32 _x)
{
	__be24 be = {
		.b = { (_x >> 16) & 0xff, (_x >> 8) & 0xff, _x & 0xff } 
	};
	return be;
}

int test1(__u32 r)
{
	union {
		__be24 be17;
		__u32 be_as_u;
	} be = {.be_as_u = 0};

	be.be17 = cpu_to_be24(r);
	__u32 cpu = be24_to_cpu(be.be17) + 1;

	printf("cpu=%x be=%x\n",cpu, be.be_as_u);
	return cpu;
}

int test2(__u32 r)
{
	union {
		__be24 be17;
		__u32 be_as_u;
	} be = {.be_as_u = 0};

	be.be17 = __cpu_to_be24(r);
	__u32 cpu = __be24_to_cpu(be.be17) + 1;

	printf("cpu=%x be=%x\n",cpu, be.be_as_u);
	return cpu;
}

int main()
{
	__u32 r = rand();
	test1(r);
	test2(r);

	return 0;
}
</test.c>

I compile it like this:
$ gcc -O1 test.c -o test
if I
$ gdb test
gdb> disass test1
gdb> disass test2

I get the exact same assembly.

What am I doing wrong ?

$ gcc --version
gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-27)

Boaz
