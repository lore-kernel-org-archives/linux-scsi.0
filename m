From: Alex Aizman <itn780@yahoo.com>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator for Linux
Date: Wed, 09 Mar 2005 18:36:37 -0800
Message-ID: <422FB2B5.3070803@yahoo.com>
References: <422BFCB2.6080309@yahoo.com> <20050309050434.GT3163@waste.org> <422E8EEB.7090209@yahoo.com> <20050309060544.GW3120@waste.org> <422E96D9.6090202@yahoo.com> <20050309222114.GF4105@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Received: from smtp105.mail.sc5.yahoo.com ([66.163.169.225]:61619 "HELO
	smtp105.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261178AbVCJChL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 21:37:11 -0500
In-Reply-To: <20050309222114.GF4105@marowsky-bree.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Matt Mackall <mpm@selenic.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Lars Marowsky-Bree wrote:

>On 2005-03-08T22:25:29, Alex Aizman <itn780@yahoo.com> wrote:
> =20
>
>>There's (or at least was up until today) an ongoing discussion on our=
=20
>>mailing list at http://groups-beta.google.com/group/open-iscsi. The=20
>>short and long of it: the problem can be solved, and it will. Couple=20
>>simple things we already do: mlockall() to keep the daemon un-swapped=
,=20
>>and also looking into potential dependency created by syslog (there's=
=20
>>one for 2.4 kernel, not sure if this is an issue for 2.6).
>>   =20
>>
>
>BTW, to get around the very same issues, heartbeat does much the same:
>lock itself into memory, reserve a couple of pages more to spare on
>stack & heap, run at soft-realtime priority.
> =20
>
Heartbeat is good for reliability, etc. WRT "getting paged-out" -=20
non-deterministic (things depend on time), right?

>syslog(), however, sucks.
> =20
>
It does.

>We went down the path of using our non-blocking IPC library to have al=
l
>our various components log to ha_logd, which then logs to syslog() or
>writes to disk or wherever.
> =20
>

=46ound ha_logd under http://linux-ha.org. The latter is extemely=20
interesting in the longer term. In the short term, there's quite a bit=20
of information on this site, need time.

>That works well in our current development series, and if you want to
>share code, you can either rip it off (Open Source, we love ya ;) or w=
e
>can spin off these parts into a sub-package for you to depend on...
>
> =20
>
If it's not a big deal :-) let's do the "sub-package" option.

>>The sfnet is a learning experience; it is by no means a proof that it=
=20
>>cannot be done.
>>   =20
>>
>
>I'd also argue that it MUST be done, because the current way of "Oh,
>it's somehow related to block stuff, must be in kernel" leads down to
>hell. We better figure out good ways around it ;-)
> =20
>
Yes, it MUST be done.

>
>Sincerely,
>    Lars Marowsky-Br=E9e <lmb@suse.de>
>
> =20
>
Alex
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
