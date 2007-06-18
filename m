From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/0] scsi_cmnd accessors issues
Date: Mon, 18 Jun 2007 23:24:33 +0900
Message-ID: <20070618232433H.fujita.tomonori@lab.ntt.co.jp>
References: <20070613194513H.fujita.tomonori@lab.ntt.co.jp>
	<46716C45.1090107@panasas.com>
	<467502AD.6090309@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:33760 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761046AbXFROY3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2007 10:24:29 -0400
In-Reply-To: <467502AD.6090309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, ed.lin@promise.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/0] scsi_cmnd accessors issues
Date: Sun, 17 Jun 2007 12:45:17 +0300

> Boaz Harrosh wrote:
> > FUJITA Tomonori wrote:
> >> There are just two llds. I suspect that we can fix them. Or they can
> >> access to the data directly (without the accessors) if we can't.
> >>
> >> I don't think that introducing something like scsi_set_sg_count, which
> >> is meaningless to most of llds, is a good idea.
> > 
> > Following are 3 patches for fixing the l-value issues for accessors.
> > 
> > 0/1 - proposed new accessors which will not let l-value code compile.
> > 0/2 - Clean fix of drivers/scsi/tmscsim.c to not need setting of sg_count
> > 0/3 - In drivers/scsi/stex.c open code of write access to request_bufflen.
> >       when new code is committed this driver will have to change with it.
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Hi Tomo.
> 
> I do not understand.
> - Do you not accept my first patch. This is to go in now for  2.6.23.
>   It is for protection against out-of-tree and the rest of the not
>   converted drivers. To not use new accessors as l-value.
> 
> - Guennadi have you had a look at second patch it is clear that SavedSGCount
>   is no longer used and that scsi_sg_count(pcmd) needs not be saved since it
>   never changes.
> 
> - Tomo, Ed. The 3rd patch was sent so the first patch can be accepted now. As
>   stated, it is a fix to the first cleanup patch that wrongfully used scsi_bufflen
>   as l-value.

As Ed (and I) said, the 3rd patch is temporary.

Now we will change:

-		scsi_bufflen(ccb->cmd) =
+		ccb->cmd->request_bufflen =
 			le32_to_cpu(*(__le32 *)&resp->variable[0]);


Then with the bidi support, we will change again:

		if (ccb->sg_table) {
			ccb->sg_table->length = 
	 			le32_to_cpu(*(__le32 *)&resp->variable[0]);


We can live without the first patch. We don't need to care about
out-of-tree drivers and we can handle the rest of the not-converted
drivers.

So I prefer applying the first patch with the bidi support and the
proper stex fix than putting the temporary third patch now thought it
doesn't matter much.

I'm not sure why you think that the first patch is so important and we
must push it to 2.6.23.
