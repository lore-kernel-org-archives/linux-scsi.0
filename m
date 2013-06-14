From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Set fDeviceInit flag to initiate device initialization
Date: Fri, 14 Jun 2013 19:25:44 +0530
Message-ID: <CALMYJDtqCHN5UYTwi+DrUrQw+6iNZMcu4q_X+5DO_OaiaCKT0A@mail.gmail.com>
References: <1370873118-18468-1-git-send-email-draviv@codeaurora.org>
 <1370873118-18468-3-git-send-email-draviv@codeaurora.org> <CALMYJDvXi7M8AgdJNpoL4H2-b3WBNZ3LLc2d8wkUMRJi5OQJQQ@mail.gmail.com>
 <51B94C54.8070209@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:47363 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3FNN4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jun 2013 09:56:07 -0400
In-Reply-To: <51B94C54.8070209@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Dolev Raviv <draviv@codeaurora.org>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>

On Thu, Jun 13, 2013 at 10:06 AM, Sujit Reddy Thumma
<sthumma@codeaurora.org> wrote:
> On 6/12/2013 11:04 AM, Santosh Y wrote:
>>>
>>>
>>>   /**
>>> + *  ufshcd_query_request() - API for issuing query request to the
>>> device.
>>> + *  @hba: ufs driver context
>>> + *  @query: params for query request
>>> + *  @descriptor: buffer for sending/receiving descriptor
>>> + *  @retries: number of times to try executing the command
>>> + *
>>> + *   All necessary fields for issuing a query and receiving its response
>>> + *   are stored in the UFS hba struct. We can use this method since we
>>> know
>>> + *   there is only one active query request or any internal command at
>>> all
>>> + *   times.
>>> + */
>>> +static int ufshcd_send_query_request(struct ufs_hba *hba,
>>> +                                       struct ufs_query_req *query,
>>> +                                       u8 *descriptor,
>>> +                                       struct ufs_query_res *response)
>>> +{
>>> +       int ret;
>>> +
>>> +       BUG_ON(!hba);
>>> +       if (!query || !response) {
>>> +               dev_err(hba->dev,
>>> +                       "%s: NULL pointer query = %p, response = %p\n",
>>> +                       __func__, query, response);
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       mutex_lock(&hba->i_cmd.dev_cmd_lock);
>>> +       hba->i_cmd.query.request = query;
>>> +       hba->i_cmd.query.response = response;
>>> +       hba->i_cmd.query.descriptor = descriptor;
>>> +
>>> +       ret = ufshcd_exec_internal_cmd(hba, DEV_CMD_TYPE_QUERY,
>>> +                                       QUERY_REQ_TIMEOUT);
>>
>>
>> Can this be generic, as external query commands might also use it?
>
>
> External query commands can call ufshcd_send_query_request() directly,
> without going into hassle of taking mutex lock and filling internal cmd
> structure.
>

I was not clear.
It might be confusing that user issued query commands also use methods
with name *internal_cmd*.

>
>>
>>> +
>>> +       hba->i_cmd.query.request = NULL;
>>> +       hba->i_cmd.query.response = NULL;
>>> +       hba->i_cmd.query.descriptor = NULL;
>>> +       mutex_unlock(&hba->i_cmd.dev_cmd_lock);
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +/**
>>
>>
>>
>
> --
> Regards,
> Sujit



-- 
~Santosh
