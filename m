From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 06/11] IB/isert: Initialize T10-PI resources
Date: Sun, 12 Jan 2014 16:12:50 +0200
Message-ID: <52D2A2E2.6040502@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>	<1389285658-7037-7-git-send-email-sagig@mellanox.com> <CAJZOPZLXNkf9XYFsDa3NcYKyySg2H_ARyrVzomYmbYQVqNRPLQ@mail.gmail.com> <52D28D96.9000207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52D28D96.9000207@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Or Gerlitz <or.gerlitz@gmail.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "oren@mellanox.com" <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 12/01/2014 14:41, Sagi Grimberg wrote:
>>> --- a/drivers/infiniband/ulp/isert/ib_isert.h
>>> +++ b/drivers/infiniband/ulp/isert/ib_isert.h
>>> @@ -48,11 +48,21 @@ struct iser_tx_desc {
>>>          struct ib_send_wr send_wr;
>>>   } __packed;
>>>
>>> +struct pi_context {
>>> +       struct ib_mr                   *prot_mr;
>>> +       bool prot_key_valid;
>>> +       struct ib_fast_reg_page_list   *prot_frpl;
>>> +       struct ib_mr                   *sig_mr;
>>> +       bool sig_key_valid;
>>> +};
>>> +
>>>   struct fast_reg_descriptor {
>>> -       struct list_head        list;
>>> -       struct ib_mr            *data_mr;
>>> -       struct ib_fast_reg_page_list    *data_frpl;
>>> -       bool                    valid;
>>> +       struct list_head                list;
>>> +       struct ib_mr                   *data_mr;
>>> +       bool data_key_valid;
>>> +       struct ib_fast_reg_page_list   *data_frpl;
>>> +       bool                            protected;
>> no need for many bools in one structure... each one needs a bit,
>> correct? so embed them in one variable
>
> I figured it will be more explicit this way. protected boolean 
> indicates if we should check the data-integrity status, and the other 
> 3 indicates if the relevant MR is valid (no need to execute local 
> invalidation). Do you think I should compact it somehow? usually 
> xxx_valid booleans will align together although not always. 

I didn't note there are so many booleans there... sure, my personal 
preference is compaction, e.g have one field names flags and multiple 
bit locations marking the different flags e.g

FAST_REG_DESC_VALID
FAST_REG_DESC_DATA_KEY_VALID
FAST_REG_DESC_PROTECTED
etc
