From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v4 4/4] scsi: ufs: inject errors to verify error handling
Date: Wed, 4 Mar 2015 22:50:52 +0900
Message-ID: <CAC5umyhjW7=oA_92SfPQu6gOzU9Qm-0EqgOGtGtVDwM9Kiz1OA@mail.gmail.com>
References: <1425308203-20695-1-git-send-email-gbroner@codeaurora.org>
	<1425308203-20695-5-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1425308203-20695-5-git-send-email-gbroner@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Davidlohr Bueso <davidlohr@hp.com>, Andi Kleen <ak@linux.intel.com>, Alexei Starovoitov <ast@plumgrid.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Al Viro <viro@zeniv.linux.org.uk>, Dan Streetman <ddstreet@ieee.or>
List-Id: linux-scsi@vger.kernel.org

2015-03-02 23:56 GMT+09:00 Gilad Broner <gbroner@codeaurora.org>:
> From: Sujit Reddy Thumma <sthumma@codeaurora.org>
>
> Use fault-injection framework to simulate error conditions
> in the controller and verify error handling mechanisms
> implemented in UFS host controller driver.
>
> This is used only during development and hence
> guarded by CONFIG_UFS_FAULT_INJECTION debug config option.

This feature looks useful, but I have a couple of comments and
question.

> +static bool inject_cmd_hang_tr(struct ufs_hba *hba)
> +{
> +       int tag;
> +
> +       tag = find_first_bit(&hba->outstanding_reqs, hba->nutrs);
> +       if (tag == hba->nutrs)
> +               return 0;
> +
> +       __clear_bit(tag, &hba->outstanding_reqs);
> +       hba->lrb[tag].cmd = NULL;
> +       __clear_bit(tag, &hba->lrb_in_use);

hba->lrb_in_use is a bitmap set by test_and_set_bit_lock().  So
this should be cleared by clear_bit_unlock().

And as soon as the bit corresponds to this slot in hba->lrb_in_use is
cleared, this slot could be reused.  But if the request corresponds
to the slot is not completed yet, it could sacrifice the new request,
too.  So should we only inject into the commands which have been
completed like this?

        tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
        completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
        tag = find_first_bit(&completed_reqs, hba->nutrs);
        ...

Or clear the corresponding bit in REG_UTP_TASK_REQ_LIST_CLEAR, just
like what inject_fatal_err_tr() does?

> +
> +       /* command hang injected */
> +       return 1;
> +}
> +
> +static int inject_cmd_hang_tm(struct ufs_hba *hba)
> +{
> +       int tag;
> +
> +       tag = find_first_bit(&hba->outstanding_tasks, hba->nutmrs);
> +       if (tag == hba->nutmrs)
> +               return 0;
> +
> +       __clear_bit(tag, &hba->outstanding_tasks);
> +       __clear_bit(tag, &hba->tm_slots_in_use);
> +
> +       /* command hang injected */
> +       return 1;
> +}

The same goes for hba->tm_slots_in_use.
