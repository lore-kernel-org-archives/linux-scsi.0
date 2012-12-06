From: Chris Boot <bootc@bootc.net>
Subject: Re: [Suggestion] drivers/target/sbp/ : set tport->tpg to NULL when
 clean up for failure.
Date: Thu, 06 Dec 2012 08:34:44 +0000
Message-ID: <50C058A4.7030403@bootc.net>
References: <50C01E16.5080303@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <50C01E16.5080303@asianux.com>
Sender: target-devel-owner@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On 06/12/12 04:24, Chen Gang wrote:
> Hello Maintainers: 
>
> in drivers/target/sbp/sbp_target.c:
>
>    tport->tpg must be NULL before process it in function sbp_make_tpg. (line 2185..2188)
>    tport->tpg assigned a ptr (line 2198)
>    if processing failed, not set tport->tpg = NULL (line 2208..2212, 2217..2221)
>
>    we have done: when free tport->tpg, set it to NULL (line 2233..2234)
>
>    is it valuable to let tport->tpg = NULL, when clean up for failure ?
>
<snip>

Yes, that's a good catch. The way it is now, if we fail to set up the
TPG, the port will be left in an inconsistent state. I'll prepare a
patch ASAP unless you'd rather do it yourself.

Thanks,
Chris

-- 
Chris Boot
bootc@bootc.net
