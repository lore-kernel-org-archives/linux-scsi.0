From: Andy Grover <agrover@redhat.com>
Subject: Re: iscsi: TargetAddress in SendTargets when bound to INADDR_ANY
Date: Mon, 16 Jan 2012 10:56:03 -0800
Message-ID: <4F1472C3.30304@redhat.com>
References: <4F0E1760.1020905@redhat.com> <1326495332.30987.73.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1326495332.30987.73.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, Dax Kelson <dkelson@gurulabs.com>, David Miller <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/13/2012 02:55 PM, Nicholas A. Bellinger wrote:
> On Wed, 2012-01-11 at 15:12 -0800, Andy Grover wrote:
>> Hi all,
>>
>> Dax discovered an issue with portals bound to 0.0.0.0 (INADDR_ANY), and
>> we've been working together to address it.
>>
>> When a portal is bound to INADDR_ANY, we return 0.0.0.0 for
>> TargetAddress in the response to iscsi SendTargets cmd. Should we
>> instead be returning the IP that the request came in on, or perhaps emit
>> TargetAddress for each active interface?
>>
>> Thanks -- Regards -- Andy
>>
>> PS I was initially tempted to just not return TargetAddress (it's
>> optional) since we don't support redir, but it's needed for MC/S as well..
>> PPS any tips on how to get the needed info from the struct iscsi_cmd
>> passed to iscsit_build_sendtargets_response?
> 
> So the sanitized string output is saved into iscsi_conn->login_ip from
> initial lookup via ->getname() in __iscsi_target_login_thread()..
> 
> However, as you mentioned this would still be an issue with MC/S where a
> client would have to perform explicit discovery to each IP address that
> could be used in a multiple connection session with in-band discovery.
> 
> I'm tempted to say that solving this in the kernel is the wrong
> approach, and that we should depend upon higher level userspace code to
> explictly create network portals via normal configfs means for us to
> simulate INADDR_ANY operation based on the configured interfaces..  I'm
> leaning this way because I'm not aware of an expected method to walk
> configured IP addresses to achieve what would be required here for a
> purely kernel-level solution..
> 
> Perhaps DaveM (Cc'ed) has some input here..?

Hi Nick,

[+CC linux-scsi]

I thought about this a little over the weekend and I think the best
thing to do might be this:

for portal in tpg.portals
  if portal.ip == INADDR_ANY
    emit TargetAddress <incoming connection IP & port>
  else
    emit TargetAddress portal.ip & port

This lets us use INADDR_ANY and not fake it from userland for the
non-MC/S case, the common case. MC/S still works, you just can't
wildcard your IP, but rather explicitly state IPs, and then they will be
returned properly.

Regards -- Andy
