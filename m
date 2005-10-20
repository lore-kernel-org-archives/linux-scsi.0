From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 12:08:24 -0400
Message-ID: <4357C0F8.3030400@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F08AE@nacos172.co.lsil.com> <4356B3D3.1010203@adaptec.com> <20051020141123.GA7119@lst.de> <4357B7C5.9000709@adaptec.com> <20051020154942.GA12809@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33183 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932334AbVJTQI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 12:08:29 -0400
In-Reply-To: <20051020154942.GA12809@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/20/05 11:49, Christoph Hellwig wrote:
> <lots of useless rants snipped>

Hi Christoph,

For some reason I thought that I was quoting specs
and showing constructive ideas (i.e. things you can sit down
and start coding).

I'm sorry that you feel that it is "useless rants".

On a topic note: It appears that the "sas transport attributes" are
nothing more than SDI/CSMI.

> Yes, we have two cases, local phy and phy on an expander.  The proper
> way to support remote phys is via smp passthru as we hopefully agree.
> Right now the sas transport class doesn't do smp passthru (although
> I'm working on it) so we only implement local link stats.

You are so much better off implementing SDI/CSMI as per the spec.

Normally, at companies, projects have a "specificaion" and "required
functionality".  What is the "specificaion" and "required functionality"
at hand?

Note that there are LSI/HP customers who are completely _happy_
to use CSMI as provided by LSI and they are not interested in 
what-have-you-not.

The easiest way to make those customers happy and keep them happy is
to provide general SDI/CSMI facitliy and _you have a spec on that_.

> Once we have
> smp passthru we can support link stats, in one of two ways:
> 
>  - do it in userland as in your example program.  in that case we don't
>    need to do anything in kernel land and need the local_attached flag
>    to disable this functionality for expander phys.
>  - do it in kernel, in which case the transport class must call the smp
>    passthru entry point of the driver to query link stats, so it needs
>    the local_attached flag aswell for that.
> 
> What's your problem with the flag now?

It is ugly, it is a (brown) paper bag solution, it is a work around.

Take a look at the phy attributes as per the SAS spec.  Then take
a look at struct sas_phy in include/scsi/sas/sas_class.h.  Do you
see such a flag in either reference?

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
