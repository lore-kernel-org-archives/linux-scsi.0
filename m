From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: advansys: fix uninitialized data access
Date: Tue, 04 Apr 2017 19:40:27 -0400
Message-ID: <yq1h923vj10.fsf@oracle.com>
References: <20170323150226.249217-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170323150226.249217-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Thu, 23 Mar 2017 16:02:18 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

Arnd,

> drivers/scsi/advansys.c: In function 'AscMsgOutSDTR':
> drivers/scsi/advansys.c:3860:26: error: '*((void *)&sdtr_buf+5)' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>          ((ushort)s_buffer[i + 1] << 8) | s_buffer[i]);
>                           ^
> drivers/scsi/advansys.c:3860:26: error: '*((void *)&sdtr_buf+7)' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/scsi/advansys.c:3860:26: error: '*((void *)&sdtr_buf+5)' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/scsi/advansys.c:3860:26: error: '*((void *)&sdtr_buf+7)' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>
> The code has existed in this exact form at least since v2.6.12, and the
> warning seems correct. This uses named initializers to ensure we initialize
> all members of the structure.
>  					(uchar *)&sdtr_buf,

Applied to 4.12/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
