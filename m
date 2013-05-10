From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH v4 1/6] scsi: ufs: wrap the i/o access operations
Date: Fri, 10 May 2013 10:52:34 +0900
Message-ID: <000001ce4d21$0ac00920$20401b60$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
 <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <002401ce4bc7$cda068a0$68e139e0$%jun@samsung.com>
 <CALMYJDtFA9PTu++4ijuUujOU=N9Sw=+=pH4KpTCVqLQmL6uE7A@mail.gmail.com>
 <000201ce4c58$e3bc3b00$ab34b100$%jun@samsung.com>
 <CALMYJDuj9SH8isLD-CjOivBAGE80P85KkUTErki-PJFXH3Scgw@mail.gmail.com>
 <000901ce4c7f$f47fd920$dd7f8b60$%jun@samsung.com>
 <CALMYJDudt2T1QXH6AidO31by_UfeLRFiz6VBz7GqApMn_kw63g@mail.gmail.com>
 <1368109310.1966.3.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55338 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3EJBwg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 21:52:36 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMK00FVC7UZB470@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 10 May 2013 10:52:35 +0900 (KST)
In-reply-to: <1368109310.1966.3.camel@dabdike>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Santosh Y' <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>

On Thursday, May 09, 2013, James Bottomley wrote:
> On Thu, 2013-05-09 at 12:22 +0530, Santosh Y wrote:
> > On Thu, May 9, 2013 at 12:09 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > > On Thursday, May 09, 2013 Santosh wrote:
> > >> > There are two patches remained. These are applied with your final comments.
> > >> > Do you have any idea?
> > >> > [PATCH v4 5/6] scsi: ufs: add dme configuration primitives
> > >> > [PATCH v4 6/6] scsi: ufs: add dme control primitives
> > >> >
> > >>
> > >> Since there is no use case for these implementations yet, except for
> > >> ufshcd_get_dme_attr_val(), as per James's suggestion
> > >> [http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg20207.html]
> > >> I did not ACK the patches.
> > >> The same patches can be used to implement related features and resubmit later.
> > > I respect your decision. But I have another opinion.
> > > The remained patches are basic operations which should be supported by ufshcd.
> > > Especially, dme_set/set will be used in vender specific part of host controller rather than in
> ufshcd itself.
> > > And above all, Maya Erez completed to test and reported working fine.
> > > If these patches are merged this time, it would be helpful to various hosts.
> > >
> >
> > I'm ok with merging these patches if James is fine with it. I will ACK
> > the patches.
> 
> Well, no, not really.  The rule is simple: we don't add new functions to
> the kernel without callers.  The reason is also simple: trying to do
> interface first and then user some time later is a "make work"
> development strategy that practically guarantees the interface is either
> never used or needs modification.  From the kernel's point of view,
> which is more important, review of a function with no callers is only
> partial because you've no idea how it will be used.  Whereas if you
> review a function and its callers, you can see how the API works and
> possibly suggest improvements.

Thank you for your feedback.
Okay, it will be reintroduced with actual usage soon.
Could you pick the remains except [5/6, 6/6] into your tree?
The following patches include Santosh's ack.
[PATCH v4 1/6] scsi: ufs: wrap the i/o access operations
[PATCH v4 2/6] scsi: ufs: amend interrupt configuration
[PATCH v4 3/6] scsi: ufs: fix interrupt status clears
[PATCH v4 4/6] scsi: ufs: rework link start-up process

Thanks,
Seungwon Jeon
> 
> James
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

