From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Thu, 1 Nov 2018 03:05:30 +0200
Message-ID: <3839ac8c-145c-9046-32d0-ab434dcee578@electrozaur.com>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org>
 <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org>
 <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox>
 <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org>
 <CAKwvOdnYx60JkJHJkD7CYA9yx5Oa7Tn9q4aZ3-tcZGx++yoduQ@mail.gmail.com>
 <1540589437.66186.124.camel@acm.org>
 <CAKwvOdm-xYRqCBXhLC1ceC44_rEmggW4qiSgGpRkpL+p-NadVg@mail.gmail.com>
 <1540591147.66186.127.camel@acm.org>
 <CAKwvOdmUhtK10cbYFoEJJp4O8LA_F-+f68A_NcL_fm_FH6QodA@mail.gmail.com>
 <1540592684.66186.136.camel@acm.org> <yq1o9bfcydm.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1o9bfcydm.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On 27/10/18 16:28, Martin K. Petersen wrote:
> 
> Bart,
> 
>> Removing kernel drivers that are not used helps to reduce the workload
>> of a maintainer and hence is a rational action. Additionally, if
>> anyone would ever complain about removal of a kernel driver, it can be
>> brought back by reverting the commit through which it has been
>> removed.  Martin, please reply if you see this differently.
> 
> We remove crusty old SCSI drivers all the time. The heuristic is based
> on lack of user bug reports and absence of commits that are not due to
> kernel interface changes or trivial cleanups. So removing stuff is
> perfectly normal.
> 
> The OSD protocol failed to get traction in the industry, adoption was
> very limited. 

Very true.

> If the code just plugged straight into existing kernel
> interfaces it would be easier to justify keeping it around. 

It was using the very much straight existing kernel interfaces
at the time of its insertion, basically the regular PC_command
(As opposed to FS_commnnd) Where the CDB/scsi_command content is
provided by the caller. And the commands complete as an whole.
Plus the added support for bidi PC_commands.

Please tell me what are those entangled interfaces you are unhappy with?
I would like to help disentangle them.

> However, the
> OSD support requires bidirectional command support so we carry a bunch
> of additional plumbing in both block and SCSI to accommodate it. There
> are no other users of these interfaces, so dropping OSD would mean we
> could simplify some (hot) code paths. That would be a win in my book.

But OSD is not the only one or scsi command-set that is using bidi. There
are a few more uses of scsi and BTW block-layer bidi commands in the field.
Target drivers been supporting bidi commands. Vendor drivers use bidi interface
for management CDBS. I'm afraid that by the Linus rules you cannot remove bidi.
Orthogonal to t10-osd or not to be.

> Consequently, if a patch were to materialize that disentangled and
> removed OSD, I'd be inclined to merge it.
> 

Is there a way I can help with this?

> But I do think that this is an orthogonal discussion to the innocuous
> __weak attribute cleanup.
> 

Thanks
Boaz
