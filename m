Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA333C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 17:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A049E2388D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 17:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgLGR1r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbgLGR1r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 12:27:47 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FC412388D;
        Mon,  7 Dec 2020 17:27:05 +0000 (UTC)
Date:   Mon, 7 Dec 2020 12:27:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Message-ID: <20201207122703.0190adf9@gandalf.local.home>
In-Reply-To: <DM6PR04MB6575CD229D3F6E1C1B30B11EFCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
        <20201206164226.6595-4-huobean@gmail.com>
        <DM6PR04MB6575197B8626D3F91C9231C4FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20201207103708.66897ef3@gandalf.local.home>
        <DM6PR04MB6575CD229D3F6E1C1B30B11EFCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Dec 2020 16:40:51 +0000
Avri Altman <Avri.Altman@wdc.com> wrote:

> > 
> > On Mon, 7 Dec 2020 07:57:27 +0000
> > Avri Altman <Avri.Altman@wdc.com> wrote:
> >   
> > > >
> > > >         TP_printk(
> > > > -               "%s: %s: HDR:%s, CDB:%s",
> > > > +               "%s: %s: HDR:%s, %s:%s",
> > > >                 __get_str(str), __get_str(dev_name),
> > > >                 __print_hex(__entry->hdr, sizeof(__entry->hdr)),
> > > > +               __get_str(tsf_type),  
> > > This breaks what current parsers expects.
> > > Why str is not enough to distinguish between the command?  
> > 
> > Hopefully it shouldn't. Reading from user space should use the
> > libtraceevent library, that reads the format files and extracts the raw
> > data to find the fields. As long as the field exists, it should not break
> > user space parsers. If it does, please let me know, and I'll gladly help
> > change the user space code to use libtraceevent :-)  
> Hi Steve,
> Thanks. I wasn't aware of libtraceevent - is this a new thing?

Actually, it's been around almost as long as ftrace. But unfortunately,
it's just now becoming a separate library. It was originally developed for
trace-cmd, but has been copied into perf, power-top and rasdaemon. But this
copying is inefficient and a maintenance nightmare, and we finally have the
library as a stand alone, and hopefully will be delivered by distributions
(I believe they are packaging it).

   https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

Looks like distros are starting to catch on.

  https://packages.debian.org/unstable/libtraceevent-dev


We are currently working on libtracefs

  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

Which will make it a lot easier for applications to interact with the
tracefs file system. I'm hoping to have this ready for distros by the end
of the year. We have applications coming that depend on these.

> 
> We have a relatively sophisticated analysis platform that utilizes raw traces,
> Among which the upiu trace is the most important and informative.
> 
> This tool has evolved over the years, adding more and more parsers per need,
> and the users are picking the appropriate parser per the trace they used.
> 
> We will surely be glad to adopt new tracing capabilities,

I think libtraceevent and libtracefs would be a much welcome addition for
upiu trace as it would be reading raw data (very fast), and have an API
that makes doing so much simpler. For example, I just wrote a quick program
that checks what files an application opens (this is not in anyway
production ready):

  http://rostedt.org/code/show-open-files.c

> But we would prefer not to break anything.

Of course!

And again, I would be happy to help out in converting to this libraries. It
will make your applications more robust, as they make it so that you do not
need to rely on the order of fields.

Note, there's plans on making these libraries python modules as well (to
have python scripts enable and read ftrace data).

-- Steve
