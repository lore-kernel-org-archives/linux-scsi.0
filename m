From: sagi grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 7/9] target: Enable WRITE_INSERT emulation in target_execute_cmd
Date: Mon, 7 Apr 2014 11:13:50 +0300
Message-ID: <53425E3E.3080509@mellanox.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>	 <1396517753-23546-8-git-send-email-nab@daterainc.com>	 <5342562F.1070706@dev.mellanox.co.il> <1396858271.19888.9.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396858271.19888.9.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On 4/7/2014 11:11 AM, Nicholas A. Bellinger wrote:
>> Looks good to me.
>>
>> Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
>>
>> This is useless though without the code setting this prot_op in
>> sbc_set_prot_op_checks()...
> Not sure I follow..  sbc_set_prot_op_checks() is already setting
> TARGET_PROT_DOUT_INSERT when no protect field in the WRITE CDB has been
> set, eg:
>
> static int
> sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
>                         bool is_write, struct se_cmd *cmd)
> {
>          if (is_write) {
>                  cmd->prot_op = protect ? TARGET_PROT_DOUT_PASS :
>                                           TARGET_PROT_DOUT_INSERT;
>
>                  <SNIP>
>          }
> }
>
> Which in-turn is what causes this code to invoke sbc_dif_write_insert
> (now sbc_dif_generate) when the backend supports PI, and the fabric
> itself does not support WRITE_INSERT hw offload.

pphh,

I confused this with DOUT_STRIP/DIN_INSERT.
You can discard.

Sagi.
