From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] qla2xxx: Fix endianness of task management response code
Date: Fri, 21 Sep 2012 01:09:10 -0700
Message-ID: <CAG4TOxOehsQz++nWWOGw12Zyp2AsWbrQy9D4faLxuay=2jXDZA@mail.gmail.com>
References: <1348006256-23551-1-git-send-email-roland@kernel.org>
 <1348041561.2479.14.camel@dabdike.int.hansenpartnership.com>
 <CAG4TOxMffy5ygGJ2ba8jFNmLx49e6p72RRgt8t=Sts1ypQofkA@mail.gmail.com> <1348214576.2468.1.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1348214576.2468.1.camel@dabdike.int.hansenpartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 21, 2012 at 1:02 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> The data in status1 appears to get used a word at a time ... what about
> the other three bytes you don't set; are they guaranteed to be zero? (in
> which case this works, it just looks wrong from the way the thing is
> used in the rest of the code).

Yes, the structure comes from

        ctio = (struct ctio7_to_24xx *)qla2x00_alloc_iocbs(ha, NULL);

a few lines earlier, and that does:

	/* Prep packet */
	memset(pkt, 0, REQUEST_ENTRY_SIZE);

before

	return pkt;
