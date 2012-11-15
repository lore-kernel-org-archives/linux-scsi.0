From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] target/sbc: Make WRITE_SAME check differentiate
 between UNMAP=[1,0]
Date: Thu, 15 Nov 2012 05:52:20 -0500
Message-ID: <20121115105220.GB28956@infradead.org>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
 <1352405238-23267-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352405238-23267-2-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> +	if (flags[0] & 0x08)
> +		cmd->se_cmd_flags |= SCF_WRITE_SAME_DISCARD;

I don't like this flag at all.  We can still simply check the CDB
during ->execute_cmd and avoid this redundant flag.

Except for that bit the changes look fine, but should not be a patch
on their own.  Without an actual implementation this relaxation is
actively harmful.
