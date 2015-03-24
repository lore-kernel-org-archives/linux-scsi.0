From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/3] iscsi-target: Convert iscsi_thread_set usage to kthread.h
Date: Tue, 24 Mar 2015 18:37:52 +0200
Message-ID: <551192E0.509@dev.mellanox.co.il>
References: <1426918564-22581-1-git-send-email-nab@daterainc.com> <1426918564-22581-2-git-send-email-nab@daterainc.com> <55100547.2090208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <55100547.2090208@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Slava Shwartsman <valyushash@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 3/23/2015 2:21 PM, Sagi Grimberg wrote:
> On 3/21/2015 8:16 AM, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>
>> This patch converts iscsi-target code to use modern kthread.h API
>> callers for creating RX/TX threads for each new iscsi_conn descriptor,
>> and releasing associated RX/TX threads during connection shutdown.
>>
>> This is done using iscsit_start_kthreads() -> kthread_run() to start
>> new kthreads from within iscsi_post_login_handler(), and invoking
>> kthread_stop() from existing iscsit_close_connection() code.
>>
>> Also, convert iscsit_logout_post_handler_closesession() code to use
>> cmpxchg when determing when iscsit_cause_connection_reinstatement()
>> needs to sleep waiting for completion.
>
> I'll run some tests with this.

Hi Nic,

I can report that this series (minus patch 3/3 and along with some
patches I'll send out soon) seems to resolve the list corruption issue
I've seen.

Overall the patches look good to me so feel free to include
patches 1+2 with:

Tested-by: Sagi Grimberg <sagig@mellanox.com>

Thanks!
Sagi.
