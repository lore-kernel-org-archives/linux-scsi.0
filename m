From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 19:56:37 +0900
Message-ID: <20080130195635T.tomof@acm.org>
References: <adazluoe2t3.fsf@cisco.com>
	<20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	<e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35040 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYA3K5A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 05:57:00 -0500
In-Reply-To: <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 09:38:04 +0100
"Bart Van Assche" <bart.vanassche@gmail.com> wrote:

> On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >
> > iSER has parameters to limit the maximum size of RDMA (it needs to
> > repeat RDMA with a poor configuration)?
> 
> Please specify which parameters you are referring to. As you know I

Sorry, I can't say. I don't know much about iSER. But seems that Pete
and Robin can get the better I/O performance - line speed ratio with
STGT.

The version of OpenIB might matters too. For example, Pete said that
STGT reads loses about 100 MB/s for some transfer sizes for some
transfer sizes due to the OpenIB version difference or other unclear
reasons.

http://article.gmane.org/gmane.linux.iscsi.tgt.devel/135

It's fair to say that it takes long time and need lots of knowledge to
get the maximum performance of SAN, I think.

I think that it would be easier to convince James with the detailed
analysis (e.g. where does it take so long, like Pete did), not just
'dd' performance results.

Pushing iSCSI target code into mainline failed four times: IET, SCST,
STGT (doing I/Os in kernel in the past), and PyX's one (*1). iSCSI
target code is huge. You said SCST comprises 14,000 lines, but it's
not iSCSI target code. The SCSI engine code comprises 14,000
lines. You need another 10,000 lines for the iSCSI driver. Note that
SCST's iSCSI driver provides only basic iSCSI features. PyX's iSCSI
target code implemenents more iSCSI features (like MC/S, ERL2, etc)
and comprises about 60,000 lines and it still lacks some features like
iSER, bidi, etc.

I think that it's reasonable to say that we need more than 'dd'
results before pushing about possible more than 60,000 lines to
mainline.

(*1) http://linux-iscsi.org/
