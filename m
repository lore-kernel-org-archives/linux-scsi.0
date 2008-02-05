From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 12:37:07 -0600
Message-ID: <1202236627.3133.55.camel@localhost.localdomain>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core>
	 <1202166033.3096.141.camel@localhost.localdomain>
	 <1202166745.11265.662.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56774 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbYBEShN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 13:37:13 -0500
In-Reply-To: <1202166745.11265.662.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Julian Satran <Julian_Satran@il.ibm.com>

This email somehow didn't manage to make it to the list (I suspect
because it had html attachments).

James

---

                              From: 
Julian Satran
<Julian_Satran@il.ibm.com>
                                To: 
Nicholas A. Bellinger
<nab@linux-iscsi.org>
                                Cc: 
Andrew Morton
<akpm@linux-foundation.org>, Alan
Cox <alan@lxorguk.ukuu.org.uk>, Bart
Van Assche
<bart.vanassche@gmail.com>, FUJITA
Tomonori
<fujita.tomonori@lab.ntt.co.jp>,
James Bottomley
<James.Bottomley@HansenPartnership.com>, ...
                           Subject: 
Re: Integration of SCST in the
mainstream Linux kernel
                              Date: 
Mon, 4 Feb 2008 21:31:48 -0500
(20:31 CST)


Well stated. In fact the "layers" above ethernet do provide the services 
that make the TCP/IP stack compelling - a whole complement of services.
ALL services required (naming, addressing, discovery, security etc.) will 
have to be recreated if you take the FcOE route. That makes good business 
for some but not necessary for the users. Those services BTW are not on 
the data path and are not "overhead".
The TCP/IP stack pathlength is decently low. What makes most 
implementations poor is that they where naively extended in the SMP world. 
Recent implementations (published) from IBM and Intel show excellent 
performance (4-6 times the regular stack). I do not have unfortunately 
latency numbers (as the community major stress has been throughput) but I 
assume that RDMA (not necessarily hardware RDMA) and/or the use of 
infiniband or latency critical applications - within clusters may be the 
ultimate low latency solution. Ethernet has some inherent latency issues 
(the bridges) that are inherited by anything on ethernet (FcOE included). 
The IP protocol stack is not inherently slow but some implementations are 
somewhat sluggish.
But instead of replacing them with new and half backed contraptions we 
would be all better of improving what we have and understand.

In the whole debate of around FcOE I heard a single argument that may have 
some merit - building convertors iSCSI-FCP to support legacy islands of 
FCP (read storage products that do not support iSCSI natively) is 
expensive. It is correct technically - only that FcOE eliminates an 
expense at the wrong end of the wire - it reduces the cost of the storage 
box at the expense of added cost at the server (and usually there a many 
servers using a storage box). FcOE vendors are also bound to provide FCP 
like services for FcOE - naming, security, discovery etc. - that do not 
exist on Ethernet. It is a good business for FcOE vendors - a duplicate 
set of solution for users.

It should be apparent by now that if one speaks about a "converged" 
network we should speak about an IP network and not about Ethernet.
If we take this route we might get perhaps also to an "infrastructure 
physical variants" that support very low latency better than ethernet and 
we might be able to use them with the same "stack" - a definite forward 
looking solution.

IMHO it is foolish to insist on throwing away the whole stack whenever we 
make a slight improvement in the physical layer of the network. We have a 
substantial investment and body of knowledge in the protocol stack and 
nothing proposed improves on it - obviously not as in its total level of 
service nor in performance.

Julo

