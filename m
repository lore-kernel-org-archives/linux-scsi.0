From: ygardi@codeaurora.org
Subject: RE: [PATCH v6 01/15] scsi: ufs: clear UTRD, UPIU req and rsp before
 new transfers
Date: Mon, 1 Feb 2016 10:40:25 -0000
Message-ID: <6945e53b5c34415df0b60c7efb9f21aa.squirrel@www.codeaurora.org>
References: <1446038045-17102-1-git-send-email-ygardi@codeaurora.org>
    <1446038045-17102-2-git-send-email-ygardi@codeaurora.org>
    <5B8DA87D05A7694D9FA63FD143655C1B41E4C272@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B41E4C272@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, "robherring2@gmail.com" <robherring2@gmail.com>, "James.Bottomley@HansenPartnership.com" <james.bottomley@hansenpartnership.com>, "pebolle@tiscali.nl" <pebolle@tiscali.nl>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "santoshsy@gmail.com" <santoshsy@gmail.com>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "gbroner@codeaurora.org" <gbroner@codeaurora.org>, "draviv@codeaurora.org" <draviv@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

>
>
>> +	cdb_len = min_t(unsigned short, lrbp->cmd->cmd_len, MAX_CDB_SIZE);
>> +	memcpy(ucd_req_ptr->sc.cdb, lrbp->cmd->cmnd, cdb_len);
>> +	if (cdb_len < MAX_CDB_SIZE)
>> +		memset(ucd_req_ptr->sc.cdb + cdb_len, 0,
>> +		       (MAX_CDB_SIZE - cdb_len));
> It's just 16 bytes, setting all to zero prior  to copy will be as good as
> this if statement
> memset(ucd_req_ptr->sc.cdb, 0, MAX_CDB_SIZE);
>

i agree. will be modified in V7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
