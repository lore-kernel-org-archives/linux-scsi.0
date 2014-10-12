From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] target: iscsi: iscsi_target_tpg.c: Cleaning up possible
 size overwriting in conjunction with sprintf
Date: Sun, 12 Oct 2014 21:32:04 +0200
Message-ID: <CAFo99gY9QBxwj_nM4xddpMze7hbY5dOu1f6_ZvErCrzwOo4LHg@mail.gmail.com>
References: <1413136558-20790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1413137923.22149.27.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1413137923.22149.27.camel@joe-AO725>
Sender: target-devel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Thomas Glanzmann <thomas@glanzmann.de>, Christophe Vu-Brugier <cvubrugier@yahoo.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2014-10-12 20:18 GMT+02:00 Joe Perches <joe@perches.com>:
> On Sun, 2014-10-12 at 19:55 +0200, Rickard Strandqvist wrote:
>> Changed same snprintf and sprintf to strlcpy and strlcat.
>> This will guarantee that the string size is not overwritten,
>> and they are significantly faster than sprintf also.
>
> I don't disagree with the change, but I think the changelog is
> misleading.
>
> strlcpy(ptr, ...) then strlcat(ptr, ...) does not use the known
> length of the first copied string and is generally not faster than
> ptr += snprintf(ptr, ...) then sprintf(ptr,...)
>
> And a couple slightly unrelated bits:
>
>> diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
>> index c3cb5c1..6fc8bfe 100644
>> --- a/drivers/target/iscsi/iscsi_target_tpg.c
>> +++ b/drivers/target/iscsi/iscsi_target_tpg.c
>> @@ -608,7 +608,6 @@ int iscsit_tpg_set_initiator_node_queue_depth(
>>  int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
>
> This function could be made static and the prototype removed from
> the .h file if it is moved above its one caller in this file.
>
>>  {
>>       unsigned char buf1[256], buf2[256], *none = NULL;
>
> Moderately large stack use here.
>



Hi

Can not agree with you about speed.
But regardless of that, it is ironically precisely the behavior you
describe that is a part of the problem.
Form the man page for snprintf
"If the output was truncated due to this limit then the return value
is the number of characters (excluding the terminating null byte)
which would have been written to the final string if enough space had
been available"

Switching to static funktion sounds good.
And less use of static memory, anyone have a more reasonable idea of a size?


Kind regards
Rickard Strandqvist
