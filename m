From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v6 01/15] scsi: ufs: clear UTRD, UPIU req and rsp before
 new transfers
Date: Mon, 2 Nov 2015 19:33:01 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B41E4C272@hasmsx108.ger.corp.intel.com>
References: <1446038045-17102-1-git-send-email-ygardi@codeaurora.org>
 <1446038045-17102-2-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1446038045-17102-2-git-send-email-ygardi@codeaurora.org>
Content-Language: en-US
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, "robherring2@gmail.com" <robherring2@gmail.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "pebolle@tiscali.nl" <pebolle@tiscali.nl>, "hch@infradead.org" <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "santoshsy@gmail.com" <santoshsy@gmail.com>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "gbroner@codeaurora.org" <gbroner@codeaurora.org>, "draviv@codeaurora.org" <draviv@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org



> +	cdb_len = min_t(unsigned short, lrbp->cmd->cmd_len, MAX_CDB_SIZE);
> +	memcpy(ucd_req_ptr->sc.cdb, lrbp->cmd->cmnd, cdb_len);
> +	if (cdb_len < MAX_CDB_SIZE)
> +		memset(ucd_req_ptr->sc.cdb + cdb_len, 0,
> +		       (MAX_CDB_SIZE - cdb_len));
It's just 16 bytes, setting all to zero prior  to copy will be as good as this if statement
memset(ucd_req_ptr->sc.cdb, 0, MAX_CDB_SIZE);
