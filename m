From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Thu, 1 Nov 2018 03:15:56 +0200
Message-ID: <65187f1a-4e67-3d96-ea97-e37c8bf87e48@electrozaur.com>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org>
 <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org>
 <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox>
 <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
Cc: bvanassche@acm.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On 26/10/18 20:54, Nick Desaulniers wrote:
<>
> 
> It's hard to say without knowing the original intent of the code.
>>From the variable's identifier and fact that it's global, I *assume*
> that we want only 1 struct osd_obj_id which is the root, hence the
> identifier `osd_root_object`.  It has 4 references in the entire
> kernel; it doesn't make sense to my why those references would want to
> be referring to two different instances of `osd_root_object`.  Maybe
> the maintainers can clarify if 2 instances is the intent?
> 
> Further complicated is the use of the __weak attribute AND the
> compiler flag -fno-common (which the kernel sets in the top level
> Makefile).  Also, it seems that ODR is a C++ concept; it's not clear
> to me if there's semantic differences with C or not (I don't think so
> in this case, but I've learned not to bet on subtle semantic
> differences between the languages not existing).
> 
> __attribute__((weak)) AND static on a global variable declared in a
> header raises many red flags to me.  Was weak added to work around an
> ODR link error?
> 
> If creating one instance of this variable is a functional change, I
> can't help but suspect the original code was wrong.  But maybe Bart,
> Boaz, or Christoph can clarify or have more thoughts on this?  Looks
> like Boaz added this header in commit de258bf5e638 ("[SCSI] libosd:
> OSDv1 Headers").
> 

Sorry for the late response. Was off line for a bit.

The original patch and all its permutations are all correct
the definition of osd_root_object is just a fancy type cast of
couple of zeros. IE a couple of zeroes with the right type. So they
can be simply compared to retuned and sent line content. So it does
not matter at all what change is accepted.

I'm so sorry for your trouble and test development. It could all
be saved if I was noticing this thread.

I will ACK again the original simple V2 patch.

Thanks
Boaz

<>
