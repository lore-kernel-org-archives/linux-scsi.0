From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: sd: Separate zeroout and discard command choices
Date: Tue, 11 Apr 2017 21:04:17 -0400
Message-ID: <yq1d1civ3la.fsf@oracle.com>
References: <20170405114111.26864-1-martin.petersen@oracle.com>
        <1491589694.2559.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39372 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbdDLBEZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 21:04:25 -0400
In-Reply-To: <1491589694.2559.16.camel@sandisk.com> (Bart Van Assche's message
        of "Fri, 7 Apr 2017 18:28:15 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>

Bart Van Assche <Bart.VanAssche@sandisk.com> writes:

Bart,

> characters then zeroing_mode_show() will truncate it. Since all
> strings in the zeroing_mode[] array are short, have you considered to
> use sprintf() instead? And if you do not want to use sprintf(), how
> about using snprintf(buf, PAGE_SIZE, ...)? I'm asking this because I'm
> no fan of magic constants.

Yeah, this was just a copy and paste from the provisioning code.

> Since sysfs guarantees that buf is '\0'-terminated, why does the above
> function call strncmp() instead of strcmp()?
>
> Can the above chain of if-statements be replaced by a for-loop such that
> zeroing_mode_store() won't have to be updated if the zeroing_mode[] array
> is modified?

I have a patch that converts sd.c to sysfs_match_string(). That's much
cleaner but will have to wait until the latter gets merged.

-- 
Martin K. Petersen	Oracle Linux Engineering
