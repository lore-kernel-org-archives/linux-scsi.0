From: Gavin Guo <gavin.guo@canonical.com>
Subject: Re: General protection fault in iscsi_rx_thread_pre_handler
Date: Sun, 1 Feb 2015 11:47:27 +0800
Message-ID: <CA+eFSM1yp8bxp2zi8OuWs=_R7ddrintYXsDx5q10eOMj2Y04NQ@mail.gmail.com>
References: <CA+eFSM1iir5QYsUALigzwcCPiqDGaNKBVq22unydN+-uTxZD2Q@mail.gmail.com>
	<1421920228.7061.48.camel@haakon3.risingtidesystems.com>
	<CA+eFSM3H2zO7+bQBd7jO2sjB-MWjGNfGTeqDZDY_8_ruzj_Q_Q@mail.gmail.com>
	<1421948107.30821.2.camel@haakon3.risingtidesystems.com>
	<CA+eFSM3yBoqpb-tjz_ztyUyUV9RQEATVJ6nBWJgXJmbXvjGgQQ@mail.gmail.com>
	<1422658406.5117.31.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1422658406.5117.31.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Nicholas,

On Sat, Jan 31, 2015 at 6:53 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Fri, 2015-01-23 at 09:30 +0800, Gavin Guo wrote:
>> Hi Nicholas,
>>
>> On Fri, Jan 23, 2015 at 1:35 AM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>> > On Thu, 2015-01-22 at 23:56 +0800, Gavin Guo wrote:
>> >> Hi Nicolas,
>> >>
>> >> On Thu, Jan 22, 2015 at 5:50 PM, Nicholas A. Bellinger
>> >> <nab@linux-iscsi.org> wrote:
>> >> > Hi Gavin,
>> >> >
>> >> > On Thu, 2015-01-22 at 06:38 +0800, Gavin Guo wrote:
>> >> >> Hi all,
>> >> >>
>> >> >> The general protection fault screenshot is attached.
>> >> >>
>> >> >> Summary:
>> >> >> The kernel is Ubuntu-3.13.0-39.66. I've done basic analysis and found
>> >> >> the fault is in list_del of iscsi_del_ts_from_active_list. And it
>> >> >> looks like deleting the iscsi_thread_set *ts two times. The point to
>> >> >> delete including iscsi_get_ts_from_inactive_list, was also checked but
>> >> >> still can't find the clue. Really appreciate if anyone can provide any
>> >> >> idea on the bug.
>> >> >>
>> >
>> > <SNIP>
>> >
>> >> >
>> >> > Thanks for your detailed analysis.
>> >> >
>> >> > A similar bug was reported off-list some months back by a person using
>> >> > iser-target + RoCE export on v3.12.y code.  Just to confirm, your
>> >> > environment is using traditional iscsi-target + TCP export, right..?
>> >>
>> >> I am sorry that I'm not an expert of the field and already google RoCE
>> >> on the internet but still don't really know what RoCE is. However, I
>> >> can provide the informations.  We used iscsiadm on the initiator side
>> >> and lio_node and tcm_node commands to create the targets for
>> >> connection. I think it should be normal  iscsi-target using TCP
>> >> export.
>> >>
>> >
>> > Yep, that would be traditional iscsi-target + TCP export.
>> >
>> >> >
>> >> > At the time, a different set of iser-target related changes ended up
>> >> > avoiding this issue on his particular setup, so we thought it was likely
>> >> > a race triggered by login failures specific to iser-target code.
>> >> >
>> >> > There was a untested patch (included inline below) to drop the legacy
>> >> > active_ts_list usage all-together, but IIRC he was not able to reproduce
>> >> > further so the patch didn't get picked up for mainline.
>> >> >
>> >> > If your able to reliability reproduce, please try with the following
>> >> > patch and let us know your progress.
>> >>
>> >> Thanks for your time reading the mail. I'll let you know the result.
>> >
>> > Just curious, are you able to reliability reproduce this bug in a VM..?
>>
>> Thanks for your caring, the machine is on the customer side, I've
>> asked and now waiting for their response.
>
> Hi Gavin,
>
> Just curious if there has been any update on this yet..?
>
> --nab
>

Really thanks for your attention. I'm also currently waiting for the
customer's reply and will send the email again to ask for the result.
However, I think the symptom may be hard to replicate that's why the
customer didn't reply me for a long time. Thanks for your time again.

Thanks,
Gavin
