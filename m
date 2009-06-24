From: James Smart <James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to do fc_remote_port_delete correctly
Date: Wed, 24 Jun 2009 12:30:52 -0400
Message-ID: <4A4254BC.6090302@emulex.com>
References: <4A4172FA.70008@cisco.com> <4A423ADE.80306@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4A423ADE.80306-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James Smart <James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


James Smart wrote:
> You never do set it to NULL. This is the role of the transport, and it 
> will do so after calling the devloss_tmo_callbk(), which is the 
> "end-of-life" indicator for the rport.
>
> If you are changing it - it can cause problems as the transport still 
> has the rport active, may make other calls, etc until 
> devloss_tmo_callbk() would occur.
>
>   
Actually, it can cause other problems if you're changing dd_data.  The 
transport will set it when it allocates the rport. As the rport can also 
be used as a container for the scsi tgt id bindings, and later reused if 
the same device comes back post devloss_tmo (in which case, it "appears" 
as a new rport to the LLDD). In this case, if you are NULL-ing the 
dd_data value, you've hosed the structure for the later use.  Let the 
tansport manage the dd_data value, you can manage the contents pointed 
to by dd_data.

-- james s
