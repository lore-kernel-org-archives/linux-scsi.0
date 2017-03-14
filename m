From: Cathy Avery <cavery@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: Add support for FC rport.
Date: Tue, 14 Mar 2017 13:10:38 -0400
Message-ID: <58C8240E.9030907@redhat.com>
References: <1489507263-21365-1-git-send-email-cavery@redhat.com>
 <20170314094221.336a1be2@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170314094221.336a1be2@xeon-e3>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, hch@infradead.org, devel@linuxdriverproject.org, dan.carpenter@oracle.com
List-Id: linux-scsi@vger.kernel.org

Good catch. Thanks!

On 03/14/2017 12:42 PM, Stephen Hemminger wrote:
> On Tue, 14 Mar 2017 12:01:03 -0400
> Cathy Avery <cavery@redhat.com> wrote:
>
>>   #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
>>   	if (host->transportt == fc_transport_template) {
>> +		struct fc_rport_identifiers ids;
>> +
>> +		ids.node_name = 0;
>> +		ids.port_name = 0;
>> +		ids.port_id = 0;
>> +		ids.roles |= FC_PORT_ROLE_FCP_TARGET;
> Since the variable ids is on the stack, it is uninitialized data.
> Doing a OR with uninitialized data is not correct.
>
> Better off to use C99 style iniatializer and skip the zero fields.
>
> 		struct fc_rport_identifiers ids = {
> 			.roles = FC_PORT_ROLE_FCP_TARGET,
> 		};
