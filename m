From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] target_core_spc: bounds check for spc_emulate_inquiry()
Date: Fri, 20 Dec 2013 23:53:00 +0100
Message-ID: <52B4CA4C.5090601@redhat.com>
References: <1387460172-27396-1-git-send-email-hare@suse.de>	 <1387460172-27396-3-git-send-email-hare@suse.de> <1387491087.5567.62.camel@haakon3.risingtidesystems.com> <52B3E7FD.9030504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52B3E7FD.9030504@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 20/12/2013 07:47, Hannes Reinecke ha scritto:
>> > 
>> > How about changing the local buffer to heap memory instead, and bumping
>> > SE_INQUIRY_BUF to 1024 bytes..?
>> > 
> Ok. But then we should have a quick check at the start
> 
> if (cmd->data_length > SE_INQUIRY_BUF)
>   len = cmd->data_length
> else
>   len = SE_INQUIRY_BUF
> 
> to catch oversized requests.

Why do you need it?  If inquiry data is always <1K,  when
cmd->data_length is large you can just need to write zeroes to the
buffer after the first SE_INQUIRY_BUF bytes.

Paolo
