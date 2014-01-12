From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 09/11] IB/isert: Accept RDMA_WRITE completions
Date: Sun, 12 Jan 2014 14:32:41 +0200
Message-ID: <52D28B69.6010304@dev.mellanox.co.il>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>	<1389285658-7037-10-git-send-email-sagig@mellanox.com> <CAJZOPZKAH6+4XPv-ua13C5skGYZHXB=tnOFT-7FSNZ5SXKhZMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJZOPZKAH6+4XPv-ua13C5skGYZHXB=tnOFT-7FSNZ5SXKhZMA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "oren@mellanox.com" <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 1/11/2014 11:14 PM, Or Gerlitz wrote:
> On Thu, Jan 9, 2014 at 6:40 PM, Sagi Grimberg <sagig@mellanox.com> wrote:
>> In case of protected transactions, we will need to check the
>> protection status of the transaction before sending SCSI response.
>> So be ready for RDMA_WRITE completions. currently we don't ask
>> for these completions, but for T10-PI we will.
>> @@ -1721,9 +1735,9 @@ __isert_send_completion(struct iser_tx_desc *tx_desc,
>>                                            isert_conn, ib_dev);
>>                  break;
>>          case ISER_IB_RDMA_WRITE:
>> -               pr_err("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
>> -               dump_stack();
>> -               break;
>> +               pr_debug("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
>> +               atomic_dec(&isert_conn->post_send_buf_count);
>> +               isert_completion_rdma_write(tx_desc, isert_cmd);
> are we doing fall through here? why?

Ohhhh, somehow i missed it in squash... Will fix, Thanks!

>>          case ISER_IB_RDMA_READ:
>>                  pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");
>
