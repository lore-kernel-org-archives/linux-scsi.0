From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Sun, 7 Feb 2016 08:02:06 -0800
Message-ID: <56B76A7E.6080903@sandisk.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
 <56B6C5D8.6070403@sandisk.com>
 <1454822367.10001.38.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454822367.10001.38.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 02/06/16 21:19, Nicholas A. Bellinger wrote:
> On Sat, 2016-02-06 at 20:19 -0800, Bart Van Assche wrote:
>> On 02/06/16 19:17, Nicholas A. Bellinger wrote:
>>> Here is -v4 series to address the set of of LUN_RESET
>>> active I/O + TMR se_cmd->cmd_kref < 0 bugs as reported
>>> recently by Quinn & Co.  This can occur during active
>>> I/O remote port TMR LUN_RESET with multi-port LIO
>>> configurations.
>>
>> Hi Nic,
>>
>> If I understood the purpose of this patch series correctly then this
>> patch series is a brave attempt to fix what is also fixed by my patch
>> called "target: Make ABORT and LUN RESET handling synchronous". Wouldn't
>> it be better to focus on that patch instead of trying to fix the current
>> approach in which TMR handling happens from the another context than the
>> command processing context ?
>>
>
> This statement is a gross oversimplification of the issues involved.
>
> If you'll recall, this was already highlighted in the context of your
> patch here:
>
> http://www.spinics.net/lists/target-devel/msg11057.html
>
> There are a number of comments on why the bug-fix was incorrect and
> broken, the basics of what needed to be done and in what order it should
> happen.
>
> But instead of replying to the comments, this was your response:
>
> http://www.spinics.net/lists/target-devel/msg11542.html
>
> If you are authentically interested in understanding the issues
> involved, you'll probably need to go back and comment on those topics
> individually, instead of ignoring them.

Hi Nic,

What you write is not correct. All your review comments that made sense 
have been addressed in the latest version of my patch 
(http://www.spinics.net/lists/target-devel/msg11666.html).

Additionally, you haven't answered my question. My question was: why to 
spend more energy on trying to fix the current approach if the LIO TMR 
handling code can be simplified greatly by handling ABORT and LUN RESET 
from the regular command execution path ?

Bart.
