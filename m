From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v4 4/4] scsi: ufs: inject errors to verify error handling
Date: Tue, 10 Mar 2015 22:09:21 +0900
Message-ID: <CAC5umyj1jJLpE90W1mpoxh6UpgzYF_p3B_=eTXOfmTboYNUULQ@mail.gmail.com>
References: <1425308203-20695-1-git-send-email-gbroner@codeaurora.org>
	<1425308203-20695-5-git-send-email-gbroner@codeaurora.org>
	<CAC5umyhjW7=oA_92SfPQu6gOzU9Qm-0EqgOGtGtVDwM9Kiz1OA@mail.gmail.com>
	<83c5d23982cd8eb481a6ff2848925331.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <83c5d23982cd8eb481a6ff2848925331.squirrel@www.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Davidlohr Bueso <davidlohr@hp.com>, Andi Kleen <ak@linux.intel.com>, Alexei Starovoitov <ast@plumgrid.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Al Viro <viro@zeniv.linux.org.uk>, Dan Streetman <ddstreet@ieee.or>
List-Id: linux-scsi@vger.kernel.org

2015-03-10 19:20 GMT+09:00 Gilad Broner <gbroner@codeaurora.org>:
>>> +static bool inject_cmd_hang_tr(struct ufs_hba *hba)
>>> +{
>>> +       int tag;
>>> +
>>> +       tag = find_first_bit(&hba->outstanding_reqs, hba->nutrs);
>>> +       if (tag == hba->nutrs)
>>> +               return 0;
>>> +
>>> +       __clear_bit(tag, &hba->outstanding_reqs);
>>> +       hba->lrb[tag].cmd = NULL;
>>> +       __clear_bit(tag, &hba->lrb_in_use);
>>
>> hba->lrb_in_use is a bitmap set by test_and_set_bit_lock().  So
>> this should be cleared by clear_bit_unlock().
>
> You are correct. Thanks.
>
>>
>> And as soon as the bit corresponds to this slot in hba->lrb_in_use is
>> cleared, this slot could be reused.  But if the request corresponds
>> to the slot is not completed yet, it could sacrifice the new request,
>> too.  So should we only inject into the commands which have been
>> completed like this?
>
> Please note that we only clear the bit in hba->lrb_in_use. scsi_done is
> not called for this request. Therefore, the tag is not yet free in the
> block layer and next calls for queuecommand will not pass down this tag to
> be used in the UFS driver. So there is no danger of a new request being
> sacrificed.

OK, I see there is no danger as far as the commands are comming
through queuecommand().  But what about the query requests?
PATCH 1/4 in this series has added ioctl interface for query
request which also acquires a tag in hba->lrb_in_use through
ufshcd_get_dev_cmd_tag().  Although it is very difficult to
happen, is it possible for new query requests to be clashed by
inject_cmd_hang_tr() in the same way I described earlier?
